# miRightClick — Yol Haritası (ROADMAP)

## Amaç

Finder'da bir klasörün içindeyken **boş alana sağ tıklandığında** bağlam
menüsünde **"New Text File"** seçeneği çıksın. Tıklanınca o klasörde
`untitled.txt` adında boş bir metin dosyası oluşsun.

## Teknik Yaklaşım

macOS'ta Finder bağlam menüsüne öğe eklemenin Apple tarafından desteklenen tek
yolu **Finder Sync Extension** (`FIFinderSync`) kullanmaktır. Boş alana sağ
tıklama olayı `FIMenuKind.contextualMenuForContainer` ile yakalanır.

Uygulama iki parçadan oluşacak:
1. **Host app (miRightClick)** — kullanıcıyı karşılayan, uzantının nasıl
   etkinleştirileceğini anlatan ve uzantıyı içinde barındıran SwiftUI uygulaması.
2. **Finder uzantısı (FinderExtension)** — menüyü çizen ve dosyayı oluşturan asıl
   mantık.

> Önemli: Finder uzantısı yalnızca **izlediği klasörlerde** menü gösterir.
> Varsayılan olarak kullanıcının **home** klasörü (ve tüm alt klasörleri)
> izlenecek. Bu aynı zamanda sandbox içinde dosya yazma iznini de sağlar.

---

## Aşamalar

### Aşama 0 — Hazırlık (bu aşamadayız)
- [x] Mevcut Xcode projesini incele (tek `app` target, bundle
      `com.metinaksu.miRightClick`, team `Y5K2497B6G`, macOS 26.5).
- [x] CLAUDE.md ve ROADMAP.md oluştur.
- [ ] **Kullanıcının başlama onayını bekle.**

### Aşama 1 — Finder Sync Extension target'ı ekle
- [ ] Projeye `FinderExtension` adında bir Finder Sync Extension target'ı ekle
      (bundle `com.metinaksu.miRightClick.FinderExtension`).
- [ ] Her iki target için imzalama (team, automatic) ve deployment hedefini ayarla.
- [ ] Host app uzantıyı `Contents/PlugIns/` altına gömsün (embed).
- [ ] Build'in temiz geçtiğini doğrula.

### Aşama 2 — Menü mantığı
- [ ] `FIFinderSync` alt sınıfı oluştur.
- [ ] `init()` içinde `directoryURLs`'i home klasörüne ayarla.
- [ ] `menu(for:)` içinde yalnızca `.contextualMenuForContainer` için menü döndür.
- [ ] Menüye **"New Text File"** öğesini ekle.

### Aşama 3 — Dosya oluşturma
- [ ] `targetedURL()` ile hedef klasörü al.
- [ ] `untitled.txt` oluştur; varsa `untitled 2.txt`, `untitled 3.txt` … şeklinde
      çakışmayı önle (asla üzerine yazma).
- [ ] Boş dosyayı `FileManager` ile yaz.

### Aşama 4 — Host app / onboarding
- [ ] ContentView'i, uzantının nasıl etkinleştirileceğini anlatan bir ekrana
      dönüştür (System Settings → General → Login Items & Extensions).
- [ ] (Opsiyonel) İzlenecek klasörleri seçtiren ayar; App Group ile uzantıya aktar.

### Aşama 5 — Test ve doğrulama
- [ ] Host app'i çalıştır, uzantıyı etkinleştir, `killall Finder`.
- [ ] İzlenen klasör altında boş alana sağ tıkla → menü görünüyor mu?
- [ ] Tıkla → `untitled.txt` oluşuyor mu? Tekrar tıkla → `untitled 2.txt`?
- [ ] Farklı klasörlerde ve alt klasörlerde davranışı doğrula.

---

## İleride Düşünülebilecekler (v2+)
- Oluşturulan dosyayı otomatik seçip yeniden adlandırma moduna sokmak.
- "New Markdown File", "New …" gibi ek dosya türleri.
- Dosya adı / uzantı / şablonun ayarlardan özelleştirilebilmesi.
- İzlenen kök klasörü tüm disk olacak şekilde genişletme seçeneği.

## Açık Sorular / Riskler
- Yeni target'ı `project.pbxproj` üzerinden elle eklemek hassastır; gerekirse
  Xcode'un "New Target" sihirbazı tercih edilebilir.
- Finder uzantısı yalnızca etkinleştirildikten sonra çalışır; her build sonrası
  `killall Finder` gerekebilir.
- macOS 26 sürümünde Login Items & Extensions ekranının yerleşimi farklı olabilir.
