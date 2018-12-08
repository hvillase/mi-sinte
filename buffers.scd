//==========================
// Librería buffers hvillase
//==========================

// Sintaxis \key de sintes: parametro/número/identificador (at1==ataque, sine), (at2g==ataque, saw, con gate) 
// Nemotemia:
// Silencios: afinados con freq, percusivos con amp
// Usar envolvente de frecuencia
// Cómo cambiar la duración de los buffers? quizá hacer varios. Tienen que ir en un doc aparte, también los efectos.

(
// === GRABACION
~durb1 = 8;
~durb2 = 8;
~b1 = Buffer.alloc(s, s.sampleRate * ~durb1, 1); // mono
~b2 = Buffer.alloc(s, s.sampleRate * ~durb2, 2); // estereo

// --- grabar buffers
(
SynthDef(\b1rec, {|in=0, ovdub=0|
	RecordBuf.ar(SoundIn.ar(in),~b1.bufnum,0,1,ovdub,loop:0,doneAction:2);
}).add
);

(
SynthDef(\b2rec, {|in1=0, in2=1, ovdub=0|
	RecordBuf.ar(SoundIn.ar([in1, in2]),~b2.bufnum,0,1,ovdub,loop:0,doneAction:2);
}).add
);

// --- reproduce buffer: trunc y mono
(
SynthDef(\b1play, {|rate = 1, st = 0, p0 = 0, a0 = 1, at0 = 0.01, r0 = 0.1, o0 = 0|
	var sen, env;
	sen = PlayBuf.ar(~b1.numChannels, ~b1.bufnum, rate, startPos:st).trunc;
	sen = Pan2.ar(sen, p0, a0);
	env = EnvGen.kr(Env.perc(at0, r0), doneAction:2);
	Out.ar(o0, sen * env);
}).add
);

// --- reproduce buffer: limpio y mono
(
SynthDef(\b1playl, {|rate=1, st=0, p0=0, a0=1, at0=0.01, r0=0.1, o0=0|
	var sen, env;
	sen=PlayBuf.ar(~b1.numChannels, ~b1.bufnum, rate, startPos:st);
	sen=Pan2.ar(sen, p0, a0);
	env=EnvGen.kr(Env.perc(at0, r0), doneAction:2);
	Out.ar(o0, sen * env);
}).add
);

// --- reproduce buffer: limpio y estéreo
(
SynthDef(\b2play,{|rate=1, st=0, a0s=1, at0s=0.01, r0s=0.01, o0s=0|
	var sen, env;
	sen = PlayBuf.ar(~b2.numChannels, ~b2.bufnum, rate, startPos:st);
	env = EnvGen.kr(Env.perc(at0s, r0s), doneAction:2);
	Out.ar(o0s, sen * env);
}).add
);
