# Pricing & License Keys

BlockGuard CLI is a premium, subscription-based service. We keep our rates highly affordable so that everyone can protect their digital privacy.

## Pricing Plans

- **Monthly Subscription:** **$2 USD per month**
- **Trial Key:** **Free for 3 Days** (Try before you buy!)

We offer flexible billing periods (Quarterly, Half-yearly, and Yearly) with discounts.

---

## 🎁 How to get a Free Trial Key
To get your free 3-day trial key, simply send us a message on Signal:

<p align="center">
  <a href="https://signal.me/#eu/5hn89XV1PsUQlPRc0WhEoUEh197WioxzFJj-CTXOGe1Boymy0-FCub3zwWXa_L3a" target="_blank">
    <img src="https://img.shields.io/badge/Signal-Message%20Us%20For%20Key-3a76f0?style=for-the-badge&logo=signal&logoColor=white" alt="Contact on Signal" />
  </a>
</p>

State that you want to request a **3-day trial key for BlockGuard CLI**. We will generate and send you a trial key instantly with absolutely no commitment or payment info required!

---

## 🔑 Activating your Key

Once you receive your key, activate it via the command line.

::: warning IMPORTANT
Always run the activation command with **`sudo`** (Linux/macOS) or as **Administrator** (Windows). This ensures the license is registered for the root user, which is required because BlockGuard binds to system-level privileged port 53.
:::

```bash
sudo blockguard activate YOUR-LICENSE-KEY
```

If successful, you will see your plan type, subscriber email, and subscription expiration date.

---

## 🔒 Device Limits & Hardware HWID
To prevent license sharing, each key has a device limit. 
- During activation, BlockGuard registers your device's unique **Hardware ID (HWID)**.
- If you reach the device limit, you can deactivate any unused machines by running:
  ```bash
  sudo blockguard reset-license
  ```
  This will immediately free up the slot on your subscription key.
