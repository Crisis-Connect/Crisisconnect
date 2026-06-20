# CrisisConnect

> Bangalore crisis support — plain language, real options, right now.

CrisisConnect is a single-page web app that helps someone in a crisis — flood displacement, a medical emergency, a food shortage, a suspicious official notice, an unsafe road — figure out **who to call, what to say, and what to bring**, in their own language, in seconds.

A person describes their situation in plain words (or photographs a document). The app uses AI to understand it, match it against a database of real Bangalore support organisations, and return a clear, personalised action card. It runs entirely in the browser — there is no backend.

This is a hackathon MVP. Some cross-device features are simulated on-device; see [What's real vs. simulated](#whats-real-vs-simulated).

---

## The problem

In a crisis, information is scattered, official language is hard to read, and systems aren't built for people under stress or with limited English. Someone could call five organisations and be turned away from each. CrisisConnect turns a panicked, plain-language description into a single ranked action plan.

---

## What it does

The app has five tabs:

| Tab | What it does |
| --- | --- |
| **🆘 Find Help** | Describe a crisis in plain language → a ranked action card: the best organisation to call, the exact phrase to say, what to bring, two fallbacks, and always-available emergency numbers. Optionally uses your location to prefer the nearest options. |
| **📋 Check a Notice** | Photograph any letter, bill, notice, or SMS → the app reads it, translates it to your language, flags whether it looks **legitimate / suspicious / likely a scam**, assigns an importance and deadline, and lists concrete next steps. |
| **🗂 Vault** | Saves checked documents on your device with deadline reminders. Items needing action soon are highlighted. |
| **📷 Report Hazard** | Photograph unsafe public infrastructure (open drain, pothole, exposed wiring) → the image is screened by AI, classified, and forwarded to the civic helpline; nearby users are alerted for emergencies. |
| **📣 Community** | A feed of hazards and emergencies reported near you, with emergencies pinned to the top. |

Every tab supports **translation and voice narration** in English, Hindi, Kannada, Tamil, Telugu, and Urdu.

---

## How the AI is used

- **Classification & retrieval** — the model classifies the crisis type and selects the best-matching organisations from a structured database, preferring those marked available and (when location is shared) physically closer.
- **Generation** — it writes the plain-language summary and the "when you call, say…" script tailored to the person's situation.
- **Vision (OCR + analysis)** — uploaded documents and hazard photos are read by a vision model that extracts text, translates, judges legitimacy, and assigns priority.
- **Translation** — summaries and action cards are translated into the selected Indian language for low-literacy and non-English readers.
- **Moderation** — every uploaded image and every message is screened before it is processed or shared, so the reporting and help features can't be misused. The help flow is deliberately lenient toward genuine distress and routes mental-health concerns to crisis helplines rather than blocking them.

---

## Run it

No build step, no install, no server.

1. Open `index.html` in any modern browser (double-click it, or `open index.html`).
2. Get a free API key from [console.groq.com/keys](https://console.groq.com/keys) (no credit card).
3. Paste the key (starts with `gsk_`) into the field at the top and press Enter.
4. Use any tab. Try a demo scenario on **Find Help** to see it end to end.

A typed key is remembered on your device (in `localStorage`) so you don't re-enter it. It is never transmitted anywhere except to Groq's API.

### Optional: skip the key prompt for everyone

To let people use the app without entering a key, copy `config.example.js` to `config.js` and paste your Groq key into it:

```
cp config.example.js config.js   # then edit config.js
```

`config.js` is git-ignored, so the key never enters the repo. **Caution:** any key shipped to the browser is visible to anyone who opens the page. For a public demo, use a disposable free key and rotate it afterwards — never commit a real key to a public repo.

### Run with location/GPS enabled

Browsers block geolocation on `file://`, so opening `index.html` directly won't trigger the GPS prompt (the in-app address bar still works). To enable GPS, run it on localhost:

- **macOS:** double-click **`start.command`** — it serves the app and opens `http://localhost:8123/index.html`.
- **Any OS:** `python3 -m http.server 8123` in this folder, then open `http://localhost:8123/index.html`.

---

## Tech stack

- **Frontend:** a single `index.html` — HTML, CSS, and vanilla JavaScript. No frameworks, no build tools.
- **AI:** [Groq](https://groq.com) free tier — `llama-3.3-70b-versatile` for text, `meta-llama/llama-4-scout-17b-16e-instruct` for vision. Called directly from the browser.
- **Browser APIs:** Geolocation (location-aware search), Web Speech (narration), FileReader + Canvas (image capture and downscaling), localStorage (vault and feed).

---

## What's real vs. simulated

In the spirit of an honest hackathon submission:

- **Real:** the AI classification, document reading, translation, legitimacy checks, image and message moderation, location-aware distance sorting, narration, and the on-device vault.
- **Simulated (clearly labelled in the UI):** forwarding hazard reports to the government, notifying nearby users, and the shared community feed. These require a multi-user backend; in this MVP they are demonstrated on-device using `localStorage`. The architecture is designed so they can be swapped for a real backend without changing the front end.

---

## Responsible AI

- **Stale-data risk:** organisation availability is based on last-reported status and may be wrong. Every result shows a timestamp and urges the user to call ahead to confirm.
- **Human in the loop:** the AI never decides eligibility for any service — it surfaces options and tells the person what to ask. The organisation decides when contacted.
- **Misuse prevention:** images and messages are AI-screened; inappropriate or irrelevant content is rejected before any analysis or sharing.
- **Not a replacement for emergency services.** For life-threatening emergencies, call **108** immediately.

---

## Privacy

Everything runs in your browser. The crisis description, uploaded images, and saved documents stay on your device (the vault uses `localStorage`). The only network calls are to Google Fonts and to Groq's API for AI processing. The API key is never persisted.

---

## License

MIT — see [LICENSE](LICENSE).
