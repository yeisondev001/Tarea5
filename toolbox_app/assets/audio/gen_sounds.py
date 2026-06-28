"""Generates 5 WAV sound effects for the Toolbox Flutter app."""
import wave, struct, math, random, os

SR = 22050  # sample rate
OUT = os.path.dirname(__file__)

def write_wav(filename, samples):
    path = os.path.join(OUT, filename)
    with wave.open(path, 'w') as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(SR)
        for s in samples:
            f.writeframes(struct.pack('<h', max(-32768, min(32767, int(s)))))
    print(f"  {filename}: {len(samples)/SR*1000:.0f} ms, {os.path.getsize(path)//1024} KB")

# 1. thud — heavy box landing (low freq + noise burst, fast decay)
def thud():
    n = int(SR * 0.30)
    out = []
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 18)
        tone = (math.sin(2*math.pi*70*t) + math.sin(2*math.pi*40*t)*0.6)
        noise = (random.random()*2-1) * 0.25
        out.append((tone + noise) * env * 0.65 * 32767)
    write_wav('thud.wav', out)

# 2. lid_open — creaky lid (sweep 200→700 Hz, soft attack)
def lid_open():
    dur = 0.22
    n = int(SR * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        p = t / dur
        freq = 200 + 500 * p
        phase += 2*math.pi*freq/SR
        env = math.sin(math.pi * p) * math.exp(-p * 2)
        out.append(math.sin(phase) * env * 0.55 * 32767)
    write_wav('lid_open.wav', out)

# 3. fan_spread — whoosh (800→220 Hz, bell envelope)
def fan_spread():
    dur = 0.28
    n = int(SR * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        p = t / dur
        freq = 800 - 580 * p
        phase += 2*math.pi*freq/SR
        env = math.sin(math.pi * p)
        out.append(math.sin(phase) * env * 0.50 * 32767)
    write_wav('fan_spread.wav', out)

# 4. card_tap — crisp UI click (1000 Hz, very short)
def card_tap():
    dur = 0.065
    n = int(SR * dur)
    out = []
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 55)
        out.append(math.sin(2*math.pi*1000*t) * env * 0.55 * 32767)
    write_wav('card_tap.wav', out)

# 5. screen_open — rising chime (1200→1800 Hz, short, bright)
def screen_open():
    dur = 0.14
    n = int(SR * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        p = t / dur
        freq = 1200 + 600 * p
        phase += 2*math.pi*freq/SR
        env = math.exp(-t * 22) * (1 - math.exp(-t * 80))
        out.append(math.sin(phase) * env * 0.55 * 32767)
    write_wav('screen_open.wav', out)

# 6. box_close — wooden clack (descending 280→90 Hz, soft thud)
def box_close():
    dur = 0.18
    n = int(SR * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        p = t / dur
        freq = 280 - 190 * p
        phase += 2*math.pi*freq/SR
        env = math.exp(-t * 14) * (1 - math.exp(-t * 120))
        wood = math.sin(phase) * 0.8 + math.sin(phase*2) * 0.2
        noise = (random.random()*2-1) * 0.1 * math.exp(-t*30)
        out.append((wood + noise) * env * 0.6 * 32767)
    write_wav('box_close.wav', out)

print("Generating sounds...")
random.seed(42)
thud()
lid_open()
fan_spread()
card_tap()
screen_open()
box_close()
print("Done!")
