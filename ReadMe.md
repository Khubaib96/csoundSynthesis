# README for change.csd

**Overview**

The `change.csd` file is a Csound score file. Csound is a sound and music computing system which allows the user to design their own instruments by writing Csound code in .csd files. This particular file, `change.csd`, is designed to process audio files in a directory, applying various audio effects and transformations.

**How it works**

The file is divided into several sections:

1. `<CsoundSynthesizer>`: This is the start of the Csound score file.

2. `<CsOptions>`: This section is empty in this file, but it's where you would normally specify command-line flags.

3. `<CsInstruments>`: This is where the instruments are defined. In this file, there are four instruments:

    * `instr 1`: This instrument processes an audio file, applying various effects such as pitch shifting, timbre modification, amplitude modulation, granular synthesis, frequency modulation, wave distortion, phase modulation, spectral morphing, wave shaping, phase distortion, and vibrato.

    * `instr 2`: This instrument writes the processed audio to an output file.

    * `instr 99`: This instrument reads all the .mp3 files in a directory, calculates the maximum length of the files, and schedules the processing and output writing for each file.

    * `instr 100`: This instrument is used for error handling. If an error occurs during processing, it writes an error message to a log file and exits the program.

4. `<CsScore>`: This section contains the score, which is a sequence of events. In this file, the score simply starts `instr 99` at time 0 for a duration of 1.

5. `</CsoundSynthesizer>`: This is the end of the Csound score file.

**How to run**

To run this Csound score, you need to have Csound installed on your computer. Once you have Csound installed, you can run the score with the following command:

```
csound --strset1="Input" .\\change.csd
```

In this command, `--strset1="Input"` sets the string variable `strset1` to `"Input"`, which is used as the directory for the input audio files. Replace `"Input"` with the path to your directory of audio files. The `.\change.csd` is the path to the `change.csd` file. Replace this with the actual path to your `change.csd` file if it's in a different location.

Please note that this command should be run in a terminal or command prompt.