<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Initialize the impulse response
giImpRespLen filelen "impulse_response.wav"
giImpulse ftgen 0, 0, giImpRespLen * sr, 1, "impulse_response.wav", 0, 0, 1

; Initialize the function table for granule and foscili
giFunctionTable ftgen 1, 0, 32768, 10, 1
giSineTable ftgen 2, 0, 8192, 10, 1

; Initialize the function table for distort
giDistortTable ftgen 3, 0, 257, 9, 0.5, 1, 270  ; sigmoid function

; Global variables for combined output
gaOutputLeft init 0
gaOutputRight init 0

instr 1
  aInLeft, aInRight soundin p4

  aIn = aInLeft + aInRight ; Mix the stereo inputs to mono for further processing

  gifftsize = int(4410)  ; New FFT size for approximately 100ms
  gioverlap = gifftsize / 4
  giwintype = 1 ; von Hann window

  fsig pvsanal aIn, gifftsize, gioverlap, gifftsize, giwintype

  kPitchShift = random(0.9, 1.1)
  kTimbreMod = random(0.9, 1.1)
  kSpatialPos = random(-1, 1)
  kAmplitudeMod = random(0.9, 1.1)
  kGranularSynth = random(0.9, 1.1)
  kFreqMod = random(0.9, 1.1)
  kWaveDistortion = random(0.9, 1.1)
  kEnvelopeVariation = random(0.1, 1.0)
  kPhaseMod = random(0.9, 1.1)
  kSpectralMorph = random(0.1, 0.9)
  kFreqModSynth = random(0.9, 1.1)
  kWaveShaping = random(0.9, 1.1)
  kPhaseDistortion = random(0.9, 1.1)
  kVibratoAmp = random(0.01, 0.1)  ; amplitude of vibrato
  kVibratoFreq = random(5, 10)     ; frequency of vibrato

  fsigShifted pvscale fsig, kPitchShift
  fsigTimbre pvsmaska fsigShifted, giFunctionTable, kTimbreMod
  aOut pvsynth fsigTimbre

  aOut = aOut * kAmplitudeMod
  aLeft, aRight pan2 aOut, kSpatialPos

  ; Process the left channel
  a5L = aLeft * kAmplitudeMod
  a6L = granule(a5L, 64, 0.5, 1, 0, giFunctionTable, 0, 0, 10, 0.0005, 50, 0.05, 50, 0.05, 30, 30, 0.5, 1, 1.42, 0.29, 2)
  a7L = foscili(0.5, kFreqMod, 1, 1, kPhaseMod, giSineTable)
  a8L = tanh(a6L * a7L * kWaveDistortion)
  kEnvVar = transeg(0.1, 0.1, -5, 1)  ; Correct usage of transeg
  a9L = a8L * kEnvVar
  a10L = foscili(a9L, kPhaseMod, 1, 1, kPhaseMod, giSineTable)
  a11L = balance(a10L, a9L, 0.5)

  fsig1L pvsanal a11L, gifftsize, gioverlap, gifftsize, giwintype
  fsig2L pvsanal a9L, gifftsize, gioverlap, gifftsize, giwintype
  kAmpSmooth = random(0.1, 0.9)  ; Example values, can be adjusted
  kFreqSmooth = random(0.1, 0.9) ; Example values, can be adjusted
  fsigMorph pvsmooth fsig1L, kAmpSmooth, kFreqSmooth
  a12L pvsynth fsigMorph

  a13L, a14L convolve a12L, "impulse_response.cva"
  a15L = foscili(a14L, kFreqModSynth, 1, 1, kFreqModSynth, giSineTable)
  a16L = foscili(a15L, kWaveShaping, 1, 1, kWaveShaping, giSineTable)
  a17L = distort(a16L, kPhaseDistortion, giDistortTable)  ; Correct usage of distort

  ; Apply vibrato
  kVibrato vibrato kVibratoAmp, kVibratoFreq, 0.01, 0.01, 3, 5, 3, 5, giSineTable
  a18L = a17L * (1 + kVibrato)

  ; Process the right channel
  a5R = aRight * kAmplitudeMod
  a6R = granule(a5R, 64, 0.5, 1, 0, giFunctionTable, 0, 0, 10, 0.0005, 50, 0.05, 50, 0.05, 30, 30, 0.5, 1, 1.42, 0.29, 2)
  a7R = foscili(0.5, kFreqMod, 1, 1, kPhaseMod, giSineTable)
  a8R = tanh(a6R * a7R * kWaveDistortion)
  kEnvVarR = transeg(0.1, 0.1, -5, 1)  ; Correct usage of transeg
  a9R = a8R * kEnvVarR
  a10R = foscili(a9R, kPhaseMod, 1, 1, kPhaseMod, giSineTable)
  a11R = balance(a10R, a9R, 0.5)

  fsig1R pvsanal a11R, gifftsize, gioverlap, gifftsize, giwintype
  fsig2R pvsanal a9R, gifftsize, gioverlap, gifftsize, giwintype
  kAmpSmoothR = random(0.1, 0.9)  ; Example values, can be adjusted
  kFreqSmoothR = random(0.1, 0.9) ; Example values, can be adjusted
  fsigMorphR pvsmooth fsig1R, kAmpSmoothR, kFreqSmoothR
  a12R pvsynth fsigMorphR

  a13R, a14R convolve a12R, "impulse_response.cva"
  a15R = foscili(a14R, kFreqModSynth, 1, 1, kFreqModSynth, giSineTable)
  a16R = foscili(a15R, kWaveShaping, 1, 1, kWaveShaping, giSineTable)
  a17R = distort(a16R, kPhaseDistortion, giDistortTable)  ; Correct usage of distort

  ; Apply vibrato
  kVibratoR vibrato kVibratoAmp, kVibratoFreq, 0.01, 0.01, 3, 5, 3, 5, giSineTable
  a18R = a17R * (1 + kVibratoR)

  ; Add the processed audio to global variables for final mix
  gaOutputLeft += a18L
  gaOutputRight += a18R

endin

instr 2
  SInputPath strget 1
  SOutputPath sprintf "%s/output.mp3", SInputPath
  fout SOutputPath, 18, gaOutputLeft, gaOutputRight
endin

instr 99
  ; Get the directory path from the command line argument
  Sdir strget 1

  ; Get the list of mp3 files in the directory
  Sfiles[] directory Sdir, ".mp3"

  ; Get the number of files
  iNumFiles = lenarray(Sfiles)

  ; Error handling: if an error occurs, log the directory and exit
  if iNumFiles == 0 then
    schedule 100, 0, 1
  endif

  ; Initialize the maximum length variable
  iMaxLen = 0

  ; Loop through each file
  iIndex = 0
  while iIndex < iNumFiles do
    ; Get the file path
    Sfile = Sfiles[iIndex]

    ; Get the file length
    iFileLen filelen Sfile

    ; Error handling: if an error occurs, log the directory and exit
    if iFileLen == 0 then
      schedule 100, 0, 1
    endif

    ; Update the maximum length
    iMaxLen = max(iMaxLen, iFileLen)

    ; Schedule processing for the file
    schedule 1, 0, iFileLen, Sfile

    ; Increment the index
    iIndex += 1
  od

  ; Schedule the final mixing
  schedule 2, 0, iMaxLen

  
endin

instr 100
  ; Error handling instrument
  Sdir strget 1
  SErrorLog sprintf "%s/error_log.txt", Sdir
  ihandle fiopen SErrorLog, 0
  Smessage sprintf "Error processing directory: %s\n", Sdir
  fprints ihandle, Smessage
  ficlose ihandle
  exitnow
endin

</CsInstruments>
<CsScore>
i 99 0 1
</CsScore>
</CsoundSynthesizer>