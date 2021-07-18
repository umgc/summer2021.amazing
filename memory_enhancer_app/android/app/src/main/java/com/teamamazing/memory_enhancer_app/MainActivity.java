package com.teamamazing.memory_enhancer_app;

/*
 * IBM Speech to Text and Text to Speech SDK use.
 * Author: Christian Ahmed
 */

import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.Toast;

import com.ibm.cloud.sdk.core.http.HttpMediaType;
import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;
import com.ibm.watson.developer_cloud.android.library.audio.MicrophoneHelper;
import com.ibm.watson.developer_cloud.android.library.audio.MicrophoneInputStream;
import com.ibm.watson.developer_cloud.android.library.audio.StreamPlayer;
import com.ibm.watson.developer_cloud.android.library.audio.utils.ContentType;
import com.ibm.watson.speech_to_text.v1.SpeechToText;
import com.ibm.watson.speech_to_text.v1.model.RecognizeOptions;
import com.ibm.watson.speech_to_text.v1.model.RecognizeWithWebsocketsOptions;
import com.ibm.watson.speech_to_text.v1.model.SpeakerLabelsResult;
import com.ibm.watson.speech_to_text.v1.model.SpeechRecognitionResults;
import com.ibm.watson.speech_to_text.v1.model.SpeechTimestamp;
import com.ibm.watson.speech_to_text.v1.websocket.BaseRecognizeCallback;
import com.ibm.watson.speech_to_text.v1.websocket.RecognizeCallback;
import com.ibm.watson.text_to_speech.v1.TextToSpeech;
import com.ibm.watson.text_to_speech.v1.model.SynthesizeOptions;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

// For Channel creation ----------------------------------------------------------------------------
import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "amazing.com/amazing_speech_service";
    private MethodChannel methodChannel;

    private SpeechToText speechService;
    private TextToSpeech textService;

    private final StreamPlayer player = new StreamPlayer();
    private MicrophoneHelper microphoneHelper;
    private MicrophoneInputStream capture;
    private boolean listening = false;

    private List<SpeechRecognitionResults> finalResults = new ArrayList<>();
    private List<SpeechRecognitionResults> speakerLabels = new ArrayList<>();
    private HashMap<Integer, String> speakerWords = new HashMap<>();

    private SpeechRecognitionResults finalResult;

    private String temporaryTranscription = "";


    // ---------------------------------------------------------------------------------------------
    // Flutter engine configuration
    // ---------------------------------------------------------------------------------------------
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel.setMethodCallHandler(
                // Note: this method is invoked on the main thread.
                (call, result) -> {
                    // Call to synthesize Text to Speech
                    System.out.println("ANDROID MethodChannel Invocation ** "+ call.method +" **");
                    if (call.method.equals("synthesizeTextToSpeech")) {
                        synthesizeTextToSpeech(call.argument("text"));
                    }
                    // Call to synthesize Text to Speech
                    else if (call.method.equals("startListening")) {
                        startListening();
                    }
                    // Call to stop synthesizing Text to Speech
                    else if (call.method.equals("stopListening")) {
                        HashMap<Integer, String> output = stopListening();
                        result.success((new JSONObject(output)).toString());
                    }
                    // No result to inspect
                    else {
                        result.notImplemented();
                    }
                }
        );
    }


    // ---------------------------------------------------------------------------------------------
    // Initialization of the new instance.
    // ---------------------------------------------------------------------------------------------
    /**
     * @param savedInstanceState the saved instance state
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        microphoneHelper = new MicrophoneHelper(this);
        speechService = initSpeechToTextService();
        textService = initTextToSpeechService();
    }


    // ---------------------------------------------------------------------------------------------
    // Listen to voice and transcribe it to text
    // ---------------------------------------------------------------------------------------------
    private void startListening() {
        if (!listening) {
            capture = microphoneHelper.getInputStream(true);
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        clearAttributes();

                        speechService.recognizeUsingWebSocket(getRecognizeOptions(capture),
                                new MicrophoneRecognizeDelegate());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
            listening = true;
        }
    }


    // ---------------------------------------------------------------------------------------------
    // Stop listening to voice and transcribe it to text
    // ---------------------------------------------------------------------------------------------
    private HashMap<Integer, String> stopListening() {
        if(listening) {
            microphoneHelper.closeInputStream();
            listening = false;
            return speakerWords;
        }

        return new HashMap<Integer, String>();
    }


    // ---------------------------------------------------------------------------------------------
    // Synthesize text to voice
    // ---------------------------------------------------------------------------------------------
    private void synthesizeTextToSpeech(String text) {
        new SynthesisTask().execute(text);
    }


    // ---------------------------------------------------------------------------------------------
    // Initialize the IBM Watson Speech to Text Service
    // ---------------------------------------------------------------------------------------------
    private SpeechToText initSpeechToTextService() {
        Authenticator authenticator = new IamAuthenticator(getString(R.string.speech_text_iam_apikey));
        SpeechToText service = new SpeechToText(authenticator);
        service.setServiceUrl(getString(R.string.speech_text_url));
        return service;
    }


    // ---------------------------------------------------------------------------------------------
    // Initialize the IBM Watson Text to Speech Service
    // ---------------------------------------------------------------------------------------------
    private TextToSpeech initTextToSpeechService() {
        Authenticator authenticator = new IamAuthenticator(getString(R.string.text_speech_iam_apikey));
        TextToSpeech service = new TextToSpeech(authenticator);
        service.setServiceUrl(getString(R.string.text_speech_url));
        return service;
    }


    // ---------------------------------------------------------------------------------------------
    // Initialize the IBM Watson Speech to Text service call options
    // ---------------------------------------------------------------------------------------------
    private RecognizeWithWebsocketsOptions getRecognizeOptions(InputStream captureStream) {
        return new RecognizeWithWebsocketsOptions.Builder()
                .audio(captureStream)
                .contentType(ContentType.OPUS.toString())
                .model(RecognizeOptions.Model.EN_US_BROADBANDMODEL)
                .speakerLabels(true)
                .interimResults(true)
                .inactivityTimeout(-1)
                .splitTranscriptAtPhraseEnd(false)
                .build();
    }


    // ---------------------------------------------------------------------------------------------
    // Handling of the transcribed text from speech
    // ---------------------------------------------------------------------------------------------
    private class MicrophoneRecognizeDelegate extends BaseRecognizeCallback implements RecognizeCallback {

        @Override
        public void onTranscription(SpeechRecognitionResults speechResults) {

            // Save final speech results
            if (speechResults.getResults() != null && !speechResults.getResults().isEmpty()) {
                if(speechResults.getResults().get(0).isXFinal()) {
                    finalResults.add(speechResults);
                    finalResult = null;
                    temporaryTranscription = speechResults.getResults().get(0).getAlternatives().get(0).getTranscript() + " ";
                }
                else {
                    finalResult = speechResults;
                }

                _notifyTranscriptionResults(speechResults.getResults().get(0).getAlternatives().get(0).getTranscript());
            }

            // Save speaker labels
            if (speechResults.getSpeakerLabels() != null && !speechResults.getSpeakerLabels().isEmpty()) {
                speakerLabels.add(speechResults);
            }
        }

        @Override
        public void onTranscriptionComplete() {
            // Add last transcription
            if (finalResults != null){
                finalResults.add(finalResult);
            }

            // Parse speakers and their words
            HashMap<Integer, String> speakerWords = processSpeakerDiarization();

            // Print speakers and their respective words
            for(Integer speaker : speakerWords.keySet()) {
                System.out.println("\n\n\n***************************************************\n\n");
                System.out.println("Speaker " + speaker + " : " + speakerWords.get(speaker));
                System.out.println("\n*****************************************************\n\n\n");
            }
            // TODO : Do something with the results
        }

        @Override
        public void onError(Exception e) {
            super.onError(e);
        }

        @Override
        public void onDisconnected() {
            super.onDisconnected();
        }

        @Override
        public void onInactivityTimeout(RuntimeException runtimeException) {
            super.onInactivityTimeout(runtimeException);
        }
    }


    // ---------------------------------------------------------------------------------------------
    // Process speaker diarization
    // ---------------------------------------------------------------------------------------------
    private HashMap<Integer, String> processSpeakerDiarization() {

        List<SpeakerLabelsResult> labels = new ArrayList<>();

        for(SpeechRecognitionResults results : speakerLabels) {
            labels.addAll(results.getSpeakerLabels());
        }

        for(SpeechRecognitionResults results : finalResults) {
            if(results == null) {
                continue;
            }

            // Handle unique speaker ---------------------------------------------------------------
            if(labels.isEmpty()) {
                speakerWords.put(
                        0,
                        results.getResults().get(0).getAlternatives().get(0).getTranscript()
                );

                return speakerWords;
            }

            // Handle multiple speakers ------------------------------------------------------------
            // For each timestamp, get the speaker label; then append text to speaker words list
            for (SpeechTimestamp timestamp : results.getResults().get(0).getAlternatives().get(0).getTimestamps()) {
                // Get speaker label for the timestamp
                int speakerLabel = getSpeakerLabel(labels, timestamp);

                // If map contains an entry for speaker already, just append word to value
                if (speakerWords.containsKey(speakerLabel)) {
                    speakerWords.put(speakerLabel, (speakerWords.get(speakerLabel) + " " + timestamp.getWord()));
                }
                // If map does not contain an entry for speaker already, add a new with the word as value
                else {
                    speakerWords.put(speakerLabel, timestamp.getWord());
                }
            }
        }

        return speakerWords;
    }


    // ---------------------------------------------------------------------------------------------
    // Get the speaker label for a timestamps; return -1 if not found.
    // ---------------------------------------------------------------------------------------------
    private int getSpeakerLabel(List<SpeakerLabelsResult> speakers, SpeechTimestamp timestamp) {
        // If from and to times match, return the speaker label
        for (SpeakerLabelsResult speaker : speakers) {
            if (equal(speaker.getFrom(), timestamp.getStartTime())
                    && equal(speaker.getTo(), timestamp.getEndTime())) {
                return speaker.getSpeaker().intValue();
            }
        }

        return -1;
    }


    // ---------------------------------------------------------------------------------------------
    // Synthesize the text and play it as a sound
    // ---------------------------------------------------------------------------------------------
    private class SynthesisTask extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... params) {
            SynthesizeOptions synthesizeOptions = new SynthesizeOptions.Builder()
                    .text(params[0])
                    .voice(SynthesizeOptions.Voice.EN_US_LISAVOICE)
                    .accept(HttpMediaType.AUDIO_WAV)
                    .build();
            player.playStream(textService.synthesize(synthesizeOptions).execute().getResult());

            System.out.println("Successful synthesis of " + params[0]);
            return "Successful synthesis.";
        }
    }


    // ---------------------------------------------------------------------------------------------
    // Handling of device permissions such as Microphone permission
    // ---------------------------------------------------------------------------------------------
    /**
     * @param requestCode the request code
     * @param permissions the permissions
     * @param grantResults the grant results
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case MicrophoneHelper.REQUEST_PERMISSION: {
                if (grantResults.length > 0 && grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "Permission to record audio denied", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }


    // ---------------------------------------------------------------------------------------------
    // Compare two double values
    // ---------------------------------------------------------------------------------------------
    private boolean equal(Float f1, Double f2) {
        BigDecimal a = new BigDecimal(f1.toString());
        BigDecimal b = new BigDecimal(f2.toString());
        return a.compareTo(b) == 0;
    }


    // ---------------------------------------------------------------------------------------------
    // Clear all attributes
    // ---------------------------------------------------------------------------------------------
    private void clearAttributes() {
        finalResults.clear();
        speakerWords.clear();
        speakerLabels.clear();
        finalResult = null;
        temporaryTranscription = "";
    }


    // ---------------------------------------------------------------------------------------------
    // Notify result
    // ---------------------------------------------------------------------------------------------
    void _notifyTranscriptionResults(String speechResult) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                methodChannel.invokeMethod(
                        "interimTranscription",
                        temporaryTranscription + speechResult);
            }
        });
    }

}
