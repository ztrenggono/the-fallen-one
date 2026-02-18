# The Fallen One - Game Design Document

**Created:** 2026-02-18  
**Engine:** Godot 4.x  
**Genre:** 3D Action RPG, Souls-like, Single-player Offline  
**Target:** Medium Prototype (6-8 bulan, 5-8 jam gameplay)

---

## 1. Premise & Story

### Setting
Dunia dengan sistem kasta keras:
- **Kasta Atas (The Sovereign)** - Bangsawan, penguasa tanah, mengontrol sumber daya
- **Kasta Menengah (The Vanguard)** - Ksatria, prajurit, penegak hukum
- **Kasta Bawah (The Forgotten)** - Rakyat biasa, pekerja, tertindas

### Backstory
Protagonist lahir di pulau terpencil. Orang tuanya mati di hari yang sama - ayah mati, ibu meninggal saat melahirkan. Bayi ini ditemukan ksatria kasta menengah yang merawatnya hingga usia 15 tahun.

### Inciting Incident
Kasta atas menemukan keberadaan mereka. Pengejaran berujung keduanya jatuh ke jurang. Ksatria mati, anak selamat. Kasta atas menganggap keduanya tewas.

### Years Later
Anak tumbuh, berlatih sendiri. Hidup hancur, dendam menyala. Suatu hari, dia menemukan kultus gelap menyummon senjata dari neraka. Dia membantai seluruh kultus dan mengangkat senjata legendaris itu - mendapatkan kekuatan dari artefak tersebut.

### Goal
Menyatukan kasta bawah + menengah untuk menggulingkan kasta atas - balas dendam atas kematian ksatria yang merawatnya.

### Theme
Balas dendam, penebusan dosa, dan pertanyaan moral - "Apakah cara yang kau pakai untuk mengalahkan monster membuatmu menjadi monster juga?"

---

## 2. World & Faction Design

### Sistem Kasta

| Kasta | Nama | Peran |
|-------|------|-------|
| Atas | The Sovereign | Bangsawan, penguasa tanah, mengontrol sumber daya |
| Menengah | The Vanguard | Ksatria, prajurit, penegak hukum |
| Bawah | The Forgotten | Rakyat biasa, pekerja, tertindas |

### Senjata Legendaris
- Senjata dari neraka yang disummon kultus
- Berbentuk pedang (seperti Excalibur) - bisa batu nancep di tanah
- Memberikan kekuatan untuk "absorb power" dari musuh yang dikalahkan
- Ada cost/konsekuensi memakainya ( TBD)

### Kultus
- Kelompok kecil yang memuja kekuatan gelap
- Sudah dihabisi protagonis di awal game
- Senjata mereka adalah "remnant" dari kejahatan mereka

### Konflik Utama
- Kasta atas menindas kasta bawah
- Kasta menengah terjepit - harus patuh ke atas tapi punya hati ke bawah
- Protagonis jembatan untuk menyatukan menengah + bawah

---

## 3. Core Gameplay Mechanics

### Combat System
- Real-time combat dengan timing-based (dodge, parry, attack)
- Stamina management (seperti Dark Souls)
- Methodical, tidak terlalu spammy
- Boss fights yang challenging

### Sistem Absorb Power
- Setelah mengalahkan musuh/boss, protagonist bisa "menyerap" kekuatan mereka
- Kekuatan bisa berupa: skill baru, passive buff, atau elemen damage
- Tree/branch untuk memilih path absorb

### Senjata Artefak
- Satu senjata utama yang evolve seiring game
- Bisa "awaken" untuk skill khusus (cooldown-based)
- Bentuk/abilities berubah saat absorb boss tertentu

### Exploration
- Open world dengan beberapa region
- Fast travel setelah unlock
- Secret area, dungeons, boss optional

### Progression
- Tidak ada level tradisional
- Power berasal dari absorb mechanic
- Player choice dalam membangun build

---

## 4. Enemy & Boss Design

### Enemy Types

**Kasta Atas (Elite Enemies):**
- Noble Guards - ksatria lengkap dengan armor berat
- Mage Nobles - penyihir yang mengontrol elemen
- Royal Executors - assassin kasta atas

**Kasta Menengah (Standard Enemies):**
- Foot Soldiers - prajurit biasa
- Knights - ksatria dengan berbagai senjata
- Archers - pemanah

**Kasta Bawah (Mob Enemies):**
- Desperate Thugs - rakyat kecil yang terpaksa jadi preman
- Cult Remnants - sisa-sisa kultus yang masih ada

**Monster/Beast:**
- Makhluk dari neraka yang kebocoran saat ritual kultus

### Boss Fights

| Boss | Deskripsi | Absorb Reward |
|------|-----------|---------------|
| The Grand Knight | Komandan ksatria yang memimpin pengejaran 15 tahun lalu | Heavy Attack Stance |
| The High Mage | Penyihir kasta atas yang menjaga wilayah penting | Elemental Magic |
| Demon General | Jenderal iblis yang berhasil masuk lewat ritual kultus | Demon Fury Mode |
| The Sovereign | Boss final - pemimpin kasta atas | Ultimate Power |

---

## 5. World Structure & Areas

### World Map (4 Region)

| Region | Deskripsi |
|--------|-----------|
| Pulau Awal | Tempat lahir, tutorial area, ruins where cult was |
| The Forgotten Slums | Daerah kasta bawah, quest untuk merekrut mereka |
| Vanguard Keep | Benteng kasta menengah, konflik politik di sini |
| Sovereign Capital | Kota kasta atas, endgame area, final boss location |

### Key Locations
- **The Abyss (Jurang)** - Tempat protagonist jatuh, area emotional significance
- **Cult Ruins** - Tempat awal game, dapat senjata artefak
- **Underground Tunnel** - Jalur rahasia antar region

### Quest Structure
- Main quest: Menyatukan faksi & menyerang kasta atas
- Side quests: Membantu NPC masing-masing kasta
- Faction reputation: Pilihan pemain mempengaruhi ending

### Playtime Target
5-8 jam untuk main story

---

## 6. Technical & Godot Implementation

### Arsitektur Project

```
game/
├── assets/
│   ├── models/         # 3D models (GLB/GLTF)
│   ├── textures/
│   ├── audio/
│   └── animations/
├── scenes/
│   ├── player/
│   ├── enemies/
│   ├── bosses/
│   ├── worlds/
│   └── ui/
├── scripts/
│   ├── combat/
│   ├── movement/
│   ├── absorb_system/
│   └── quest/
└── resources/
    ├── enemies/
    ├── items/
    └── abilities/
```

### Core Systems

| System | Pendekatan |
|--------|------------|
| State Machine | Untuk player dan enemy AI |
| Combat | Hitbox/hurtbox system dengan signals |
| Absorb Power | Resource system yang simpan ability data |
| Save/Load | Godot's built-in save system |
| Quest | Simple quest manager dengan flags |

### Recommended Learning Path
1. Player controller + basic movement
2. Combat system (attack, dodge, parry)
3. One enemy type + AI
4. Absorb mechanic prototype
5. World building + level design

---

## 7. Timeline & Milestones

### Phase 1: Foundation (Bulan 1-2)
- [x] Setup project Godot
- [x] Player controller (movement, camera)
- [x] Basic combat prototype
- [x] 1 enemy type for testing

### Phase 2: Core Systems (Bulan 3-4)
- [x] Absorb power system
- [x] Boss fight prototype (1 boss)
- [x] Health, stamina, UI
- [x] Save/Load system

### Phase 3: Content (Bulan 5-6)
- [x] Build 2-3 regions
- [x] Enemy variety (3-4 types)
- [x] 2-3 boss fights
- [x] Main quest line

### Phase 4: Polish (Bulan 7-8)
- [x] Bug fixing
- [x] Balance tuning
- [x] Audio & visual polish
- [x] Ending/credits

### Milestone Deliverables
- **End of Month 2:** Playable combat prototype
- **End of Month 4:** Core loop working (combat + absorb)
- **End of Month 6:** Playable story (start to finish)
- **End of Month 8:** Release ready prototype

---

## 8. Summary

### Hook Utama
Mantan anak yatim yang diasuh ksatria kasta menengah, dikhianati sistem kasta, mendapat senjata dari neraka, menyerap kekuatan musuh untuk balas dendam.

### Core Pillars
1. **Souls-like Combat** - Methodical, timing-based, challenging
2. **Absorb System** - Unique progression tanpa traditional leveling
3. **Faction Revolution** - Story tentang menyatukan kasta tertindas
4. **Dark Fantasy World** - Sistem kasta oppressif + elemen supernatural

### Target MVP
- 4 regions
- 4 enemy types
- 4 bosses
- Main quest complete
- Core absorb system working