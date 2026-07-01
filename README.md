# miRightClick

**[🇹🇷 Türkçe için tıklayınız](#türkçe)**

Add a **New Text File** item to Finder's right‑click menu. When you right‑click
the empty background inside a folder, choose **New Text File** and an
`untitled.txt` is created right there — the simple "new text file here" action
macOS never shipped.

## Features

- Adds **New Text File** to the Finder context menu.
- Creates `untitled.txt` in the folder you right‑clicked.
- Collision‑safe naming: `untitled.txt`, then `untitled 2.txt`, `untitled 3.txt`, …
  (never overwrites an existing file).
- Works in **every folder** (Home, Downloads, external drives, project folders…).

## Requirements

- macOS 14 (Sonoma) or later.
- Apple Silicon or Intel Mac.

## Installation

1. Download the latest **`miRightClick.dmg`** from the
   [Releases](https://github.com/metin-aksu/miRightClick/releases) page.
2. Open the `.dmg` and drag **miRightClick** into your **Applications** folder.
3. Launch **miRightClick** once from Applications.

## Enable the Finder extension

The item won't appear until you enable the extension once:

1. In the app, click **Open Extension Settings** (or open **System Settings →
   General → Login Items & Extensions**).
2. Under the Finder / extensions section, turn **miRightClick** on.
3. Restart Finder so it loads the extension. Either log out/in, or run in Terminal:
   ```bash
   killall Finder
   ```

## Usage

Right‑click the empty background inside any folder → **New Text File**. Done.

## Known limitation

macOS does **not** allow any third‑party Finder extension to add background
context‑menu items in the **Desktop** and **Documents** folders (this affects
every such app, not just miRightClick). The item appears in every other folder.

## Author

**Metin AKSU**
<https://github.com/metin-aksu/miRightClick>

---

## Türkçe

**[🇬🇧 Click for English](#mirightclick)**

Finder'ın sağ‑tık menüsüne bir **New Text File** (Yeni Metin Dosyası) seçeneği
ekler. Bir klasörün içindeki boş alana sağ tıklayıp **New Text File**'ı
seçtiğinde, tam o klasörde bir `untitled.txt` oluşturulur — macOS'un bir türlü
eklemediği "yeni metin dosyası" işlemi.

## Özellikler

- Finder'ın sağ‑tık menüsüne **New Text File** ekler.
- Sağ tıkladığın klasörde `untitled.txt` oluşturur.
- Güvenli adlandırma: `untitled.txt`, sonra `untitled 2.txt`,
  `untitled 3.txt`, … (mevcut dosyanın asla üzerine yazmaz).
- **Her klasörde** çalışır (ev, Downloads, harici diskler, proje klasörleri…).

## Gereksinimler

- macOS 14 (Sonoma) veya üzeri.
- Apple Silicon veya Intel Mac.

## Kurulum

1. [Releases](https://github.com/metin-aksu/miRightClick/releases) sayfasından
   en güncel **`miRightClick.dmg`** dosyasını indir.
2. `.dmg` dosyasını aç ve **miRightClick**'i **Applications** klasörüne sürükle.
3. **miRightClick**'i Applications'tan bir kez çalıştır.

## Finder uzantısını etkinleştir

Seçenek, uzantıyı bir kez etkinleştirene kadar görünmez:

1. Uygulamada **Open Extension Settings**'e tıkla (ya da **System Settings →
   General → Login Items & Extensions** yolunu aç).
2. Finder / uzantılar bölümünde **miRightClick**'i aç.
3. Finder'ın uzantıyı yüklemesi için onu yeniden başlat. Oturumu kapatıp aç ya da
   Terminal'de şunu çalıştır:
   ```bash
   killall Finder
   ```

## Kullanım

Herhangi bir klasörün içindeki boş alana sağ tıkla → **New Text File**. Hepsi bu.

## Bilinen kısıt

macOS, hiçbir üçüncü parti Finder uzantısının **Desktop** ve **Documents**
klasörlerinde arka plan sağ‑tık menüsü öğesi eklemesine **izin vermez** (bu, yalnızca
miRightClick'i değil bu tür tüm uygulamaları etkiler). Öğe diğer tüm klasörlerde
görünür.

## Geliştirici

**Metin AKSU**
<https://github.com/metin-aksu/miRightClick>
