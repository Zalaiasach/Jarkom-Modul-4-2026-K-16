# Laporan Resmi Praktikum Jaringan Komputer
## Modul 4: Subnetting VLSM & Routing — Kelompok K-16 (Group A)

---

### Identitas Kelompok
* **Kelompok:** K-16 (Group A)
* **IP Server Lab / Uplink Cloud0:** `10.4.89.246/24` (Gateway: `10.4.89.1`)
* **Blok Jaringan Internal:** `10.4.0.0/19` (Format Variabel: `10.xx.0.0`, dengan `xx = 4`)
* **File Simulasi Packet Tracer (.pkt):** [`K2_CIDR_OSPF.pkt`](K2_CIDR_OSPF.pkt)

| Nama Anggota | NRP |
| :--- | :--- |
| Muhammad Rifqi Fathurrahman | 50252... |
| *(Anggota Kelompok)* | 50252... |

---

## 📌 Daftar Isi
1. [Deskripsi Kasus & Desain Topologi](#1-deskripsi-kasus--desain-topologi)
2. [Analisis Kebutuhan Host & Alokasi VLSM](#2-analisis-kebutuhan-host--alokasi-vlsm)
3. [Pohon Subnetting (Tree VLSM / Hierarchy)](#3-pohon-subnetting-tree-vlsm--hierarchy)
4. [Tabel Perhitungan Subnetting Lengkap (Subnet A1 – A25)](#4-tabel-perhitungan-subnetting-lengkap-subnet-a1--a25)
5. [Tabel Alokasi IP Interface Router](#5-tabel-alokasi-ip-interface-router)
6. [Tabel Alokasi IP End-Devices (Host / Client / Server)](#6-tabel-alokasi-ip-end-devices-host--client--server)
7. [Dokumentasi & Konfigurasi CLI Router Cisco Packet Tracer](#7-dokumentasi--konfigurasi-cli-router-cisco-packet-tracer)
8. [Verifikasi Konektivitas & Pengujian Jaringan (Ping Test)](#8-verifikasi-konektivitas--pengujian-jaringan-ping-test)

---

## 1. Deskripsi Kasus & Desain Topologi

Topologi praktikum dirancang menggunakan simulator **Cisco Packet Tracer** dengan tema *Serial Experiments Lain*. Jaringan ini terdiri dari:
* **13 Unit Router Cisco 2811:** `Wired` (Core Router), `Cyberia` (Gateway Uplink Cloud), `Psyche`, `Copland`, `Schumann`, `Accela`, `Tachibana`, `Deus`, `Protocol7`, `Knights`, `Phantoma`, `Shibuya`, dan `Navi`.
* **13 Unit Switch Layer 2:** Menghubungkan berbagai segmen broadcast domain ke masing-masing router.
* **25 Unit End-Devices (Client & Server):** PC, Laptop, dan Server dengan variasi kebutuhan host mulai dari 2 host hingga 700 host.
* **1 Unit Cloud-PT (`Cloud0`):** Menghubungkan jaringan internal ke jaringan lab/internet eksternal melalui IP `10.4.89.246/24`.

### Topologi Soal Praktikum:
![Topologi Asli Soal](images/topologi_soal.png)

### Hasil Implementasi Topologi di Cisco Packet Tracer:
Seluruh perangkat berhasil dirangkai, disambungkan menggunakan kabel *Copper Straight-Through* dan *Cross-Over*, serta ditambahkan modul antarmuka FastEthernet (`NM-2FE2W` / `HWIC-4ESW`) pada router yang memiliki $\ge 3$ koneksi interface.

![Topologi Cisco Packet Tracer](images/topologi_cisco_packet_tracer.png)

---

## 2. Analisis Kebutuhan Host & Alokasi VLSM

1. **Total Kebutuhan Host Fisik Murni:**  
   $$700 + 180 + 300 + 31 + 510 + 3 + 3 + 95 + 39 + 260 + 6 + 77 + 21 + 23 + 9 + 2 + 208 + 45 + 57 + 120 + 18 + 4 + 14 + 57 + 4 = 2.786\text{ Host}$$

2. **Kebutuhan Ruang Alamat IP (Address Space):**  
   Dengan memperhitungkan pembulatan blok biner ($2^n$), kebutuhan network ID, broadcast address, IP interface router, dan link point-to-point antar-router:
   * Total ruang alamat yang teralokasi adalah **4.316 alamat IP**.
   * Karena kebutuhan $> 4.096$ alamat IP (blok `/20`), maka jaringan internal memerlukan alokasi supernet minimal **`/19` (8.192 alamat IP)**, yaitu rentang `10.4.0.0` s.d. `10.4.31.255`.

3. **Format Template Penugasan:**  
   Sesuai template praktikum, penomoran subnet dikelompokkan dengan kode **`A1, A2, dst.`**, di mana **`A1`** diawali dari blok link *Point-to-Point* (`255.255.255.252` / `/30`) pada alamat dasar `10.xx.0.0` (dengan $xx = 4$).

![Template Format Aslab](images/template_tabel_subnetting.png)

---

## 3. Pohon Subnetting (Tree VLSM / Hierarchy)

```text
10.4.0.0/19 (Total 8192 IPs: 10.4.0.0 - 10.4.31.255)
├── 10.4.0.0/20 (Blok Subnet P2P, LAN Kecil & Menengah - 4096 IPs)
│   ├── 10.4.0.0/24 (Subnet P2P /30 & LAN Direct /29, /27, /26)
│   │   ├── 10.4.0.0/28  --> [A1 s.d. A4] Link P2P /30 (Cyberia-Wired, Wired-Navi, Wired-Tachibana, Schumann-Accela)
│   │   ├── 10.4.0.16/28 --> [A5 s.d. A8] Link P2P /30 (Tachibana-Deus, Deus-P7, P7-Knights, Knights-Phantoma)
│   │   ├── 10.4.0.32/28 --> [A9] Link P2P Phantoma-Shibuya /30
│   │   ├── 10.4.0.40/29 --> [A10] Switch4 (Wired, Psyche, Copland, Schumann - Multi-router LAN)
│   │   ├── 10.4.0.48/29 --> [A11] LAN Direct Akashic (3 host)
│   │   ├── 10.4.0.56/29 --> [A12] LAN Direct Eiri (2 host)
│   │   ├── 10.4.0.64/27 --> [A13] Switch8 Phantoma - Emi (14 host)
│   │   ├── 10.4.0.128/26 --> [A14] LAN Direct Juri (31 host)
│   │   └── 10.4.0.192/26 --> [A15] Switch11 Protocol7 - Chisa & Hodgeson (32 host)
│   ├── 10.4.1.0/24 (Subnet LAN /26 & /25)
│   │   ├── 10.4.1.0/26   --> [A16] Switch2 Navi - Taro (57 host)
│   │   ├── 10.4.1.64/26  --> [A17] Switch12 Shibuya - Lain & Mika (61 host)
│   │   └── 10.4.1.128/25 --> [A18] Switch10 Deus - Lilith & Specter (98 host)
│   ├── 10.4.2.0/24 --> [A19] Switch0 Cyberia - JJ & MyuMyu (134 host)
│   ├── 10.4.3.0/24 --> [A20] Switch3 Navi - Yasuo, Miho & Kuma (142 host)
│   ├── 10.4.4.0/24 --> [A21] Switch1 Navi - Alice & Reika (253 host)
│   ├── 10.4.6.0/23 --> [A22] Switch6 Copland - Masayuki (300 host)
│   └── 10.4.8.0/23 --> [A23] Switch9 Tachibana - Collective & Ghost (266 host)
└── 10.4.16.0/20 (Blok Subnet Besar /22)
    ├── 10.4.12.0/22 --> [A24] Switch7 Accela - Omnipresence & Denpa (513 host)
    └── 10.4.16.0/22 --> [A25] Switch5 Psyche - Karl & Lin (880 host)
```

---

## 4. Tabel Perhitungan Subnetting Lengkap (Subnet A1 – A25)

Tabel berikut telah disesuaikan 100% dengan format penugasan (*Subnet, Network ID, Netmask, Broadcast, Range IP*):

| Subnet | Network ID | Netmask | Broadcast | Range IP | Keterangan / Alokasi Topologi |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **A1** | `10.4.0.0` | `255.255.255.252` | `10.4.0.3` | `10.4.0.1 - 10.4.0.2` | Point-to-Point: *Cyberia – Wired* |
| **A2** | `10.4.0.4` | `255.255.255.252` | `10.4.0.7` | `10.4.0.5 - 10.4.0.6` | Point-to-Point: *Wired – Navi* |
| **A3** | `10.4.0.8` | `255.255.255.252` | `10.4.0.11` | `10.4.0.9 - 10.4.0.10` | Point-to-Point: *Wired – Tachibana* |
| **A4** | `10.4.0.12` | `255.255.255.252` | `10.4.0.15` | `10.4.0.13 - 10.4.0.14` | Point-to-Point: *Schumann – Accela* |
| **A5** | `10.4.0.16` | `255.255.255.252` | `10.4.0.19` | `10.4.0.17 - 10.4.0.18` | Point-to-Point: *Tachibana – Deus* |
| **A6** | `10.4.0.20` | `255.255.255.252` | `10.4.0.23` | `10.4.0.21 - 10.4.0.22` | Point-to-Point: *Deus – Protocol7* |
| **A7** | `10.4.0.24` | `255.255.255.252` | `10.4.0.27` | `10.4.0.25 - 10.4.0.26` | Point-to-Point: *Protocol7 – Knights* |
| **A8** | `10.4.0.28` | `255.255.255.252` | `10.4.0.31` | `10.4.0.29 - 10.4.0.30` | Point-to-Point: *Knights – Phantoma* |
| **A9** | `10.4.0.32` | `255.255.255.252` | `10.4.0.35` | `10.4.0.33 - 10.4.0.34` | Point-to-Point: *Phantoma – Shibuya* |
| **A10** | `10.4.0.40` | `255.255.255.248` | `10.4.0.47` | `10.4.0.41 - 10.4.0.46` | Switch4 (*Wired, Psyche, Copland, Schumann*) |
| **A11** | `10.4.0.48` | `255.255.255.248` | `10.4.0.55` | `10.4.0.49 - 10.4.0.54` | LAN Direct: *Akashic (3 host)* |
| **A12** | `10.4.0.56` | `255.255.255.248` | `10.4.0.63` | `10.4.0.57 - 10.4.0.62` | LAN Direct: *Eiri (2 host)* |
| **A13** | `10.4.0.64` | `255.255.255.224` | `10.4.0.95` | `10.4.0.65 - 10.4.0.94` | Switch8: *Emi (14 host)* |
| **A14** | `10.4.0.128` | `255.255.255.192` | `10.4.0.191` | `10.4.0.129 - 10.4.0.190` | LAN Direct: *Juri (31 host)* |
| **A15** | `10.4.0.192` | `255.255.255.192` | `10.4.0.255` | `10.4.0.193 - 10.4.0.254` | Switch11: *Chisa 23 + Hodgeson 9 (32 host)* |
| **A16** | `10.4.1.0` | `255.255.255.192` | `10.4.1.63` | `10.4.1.1 - 10.4.1.62` | Switch2: *Taro (57 host)* |
| **A17** | `10.4.1.64` | `255.255.255.192` | `10.4.1.127` | `10.4.1.65 - 10.4.1.126` | Switch12: *Lain 57 + Mika 4 (61 host)* |
| **A18** | `10.4.1.128` | `255.255.255.128` | `10.4.1.255` | `10.4.1.129 - 10.4.1.254` | Switch10: *Lilith 77 + Specter 21 (98 host)* |
| **A19** | `10.4.2.0` | `255.255.255.0` | `10.4.2.255` | `10.4.2.1 - 10.4.2.254` | Switch0: *JJ 95 + MyuMyu 39 (134 host)* |
| **A20** | `10.4.3.0` | `255.255.255.0` | `10.4.3.255` | `10.4.3.1 - 10.4.3.254` | Switch3: *Yasuo 120 + Miho 18 + Kuma 4 (142 host)* |
| **A21** | `10.4.4.0` | `255.255.255.0` | `10.4.4.255` | `10.4.4.1 - 10.4.4.254` | Switch1: *Alice 208 + Reika 45 (253 host)* |
| **A22** | `10.4.6.0` | `255.255.254.0` | `10.4.7.255` | `10.4.6.1 - 10.4.7.254` | Switch6: *Masayuki (300 host)* |
| **A23** | `10.4.8.0` | `255.255.254.0` | `10.4.9.255` | `10.4.8.1 - 10.4.9.254` | Switch9: *Collective 260 + Ghost 6 (266 host)* |
| **A24** | `10.4.12.0` | `255.255.252.0` | `10.4.15.255` | `10.4.12.1 - 10.4.15.254` | Switch7: *Omnipresence 510 + Denpa 3 (513 host)* |
| **A25** | `10.4.16.0` | `255.255.252.0` | `10.4.19.255` | `10.4.16.1 - 10.4.19.254` | Switch5: *Karl 700 + Lin 180 (880 host)* |

*(Catatan: Untuk penulisan berbasis format variabel $10.xx.$, ganti angka kedua `4` menjadi `xx`)*.

---

## 5. Tabel Alokasi IP Interface Router

| Router | Interface | Alamat IP | Netmask | Perangkat Terhubung / Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| **`Router0` (Cyberia)** | `Fa0/0` | `10.4.89.246` | `255.255.255.0` | Uplink ke `Cloud0` (Lab External Network) |
| | `Fa0/1` | `10.4.2.1` | `255.255.255.0` | Gateway Switch0 (`JJ` & `MyuMyu` - Subnet A19) |
| | `Fa1/0` | `10.4.0.1` | `255.255.255.252` | Link P2P ke Router1 Wired (Subnet A1) |
| **`Router1` (Wired)** | `Fa0/0` | `10.4.0.2` | `255.255.255.252` | Link P2P ke Router0 Cyberia (Subnet A1) |
| | `Fa0/1` | `10.4.0.41` | `255.255.255.248` | SVI Switch4 (Multi-router LAN - Subnet A10) |
| | `Fa1/0` | `10.4.0.5` | `255.255.255.252` | Link P2P ke Router3 Navi (Subnet A2) |
| | `Fa1/1` | `10.4.0.9` | `255.255.255.252` | Link P2P ke Router2 Tachibana (Subnet A3) |
| **`Router4` (Psyche)** | `Fa0/0` | `10.4.0.42` | `255.255.255.248` | Interface ke Switch4 (Subnet A10) |
| | `Fa0/1` | `10.4.16.1` | `255.255.252.0` | Gateway Switch5 (`Karl` & `Lin` - Subnet A25) |
| **`Router5` (Copland)** | `Fa0/0` | `10.4.0.43` | `255.255.255.248` | Interface ke Switch4 (Subnet A10) |
| | `Fa0/1` | `10.4.6.1` | `255.255.254.0` | Gateway Switch6 (`Masayuki` - Subnet A22) |
| | `Fa1/0` | `10.4.0.129` | `255.255.255.192` | Gateway Direct ke Laptop3 `Juri` (Subnet A14) |
| **`Router7` (Schumann)**| `Fa0/0` | `10.4.0.44` | `255.255.255.248` | Interface ke Switch4 (Subnet A10) |
| | `Fa0/1` | `10.4.0.49` | `255.255.255.248` | Gateway Direct ke Server3 `Akashic` (Subnet A11)|
| | `Fa1/0` | `10.4.0.13` | `255.255.255.252` | Link P2P ke Router8 Accela (Subnet A4) |
| **`Router8` (Accela)** | `Fa0/0` | `10.4.0.14` | `255.255.255.252` | Link P2P ke Router7 Schumann (Subnet A4) |
| | `Fa0/1` | `10.4.12.1` | `255.255.252.0` | Gateway Switch7 (`Omnipresence` & `Denpa` - A24) |
| **`Router3` (Navi)** | `Fa0/0` | `10.4.0.6` | `255.255.255.252` | Link P2P ke Router1 Wired (Subnet A2) |
| | `Fa0/1` | `10.4.4.1` | `255.255.255.0` | Gateway Switch1 (`Alice` & `Reika` - Subnet A21) |
| | `Fa1/0` | `10.4.1.1` | `255.255.255.192` | Gateway Switch2 (`Taro` - Subnet A16) |
| | `Fa1/1` | `10.4.3.1` | `255.255.255.0` | Gateway Switch3 (`Yasuo`, `Miho`, `Kuma` - A20) |
| **`Router2` (Tachibana)**| `Fa0/0` | `10.4.0.10` | `255.255.255.252` | Link P2P ke Router1 Wired (Subnet A3) |
| | `Fa0/1` | `10.4.8.1` | `255.255.254.0` | Gateway Switch9 (`Collective` & `Ghost` - A23) |
| | `Fa1/0` | `10.4.0.17` | `255.255.255.252` | Link P2P ke Router9 Deus (Subnet A5) |
| **`Router9` (Deus)** | `Fa0/0` | `10.4.0.18` | `255.255.255.252` | Link P2P ke Router2 Tachibana (Subnet A5) |
| | `Fa0/1` | `10.4.1.129` | `255.255.255.128` | Gateway Switch10 (`Lilith` & `Specter` - A18) |
| | `Fa1/0` | `10.4.0.21` | `255.255.255.252` | Link P2P ke Router10 Protocol7 (Subnet A6) |
| **`Router10` (Protocol7)**| `Fa0/0` | `10.4.0.22` | `255.255.255.252` | Link P2P ke Router9 Deus (Subnet A6) |
| | `Fa0/1` | `10.4.0.193` | `255.255.255.192` | Gateway Switch11 (`Chisa` & `Hodgeson` - A15) |
| | `Fa1/0` | `10.4.0.25` | `255.255.255.252` | Link P2P ke Router11 Knights (Subnet A7) |
| **`Router11` (Knights)** | `Fa0/0` | `10.4.0.26` | `255.255.255.252` | Link P2P ke Router10 Protocol7 (Subnet A7) |
| | `Fa0/1` | `10.4.0.57` | `255.255.255.248` | Gateway Direct ke Server5 `Eiri` (Subnet A12) |
| | `Fa1/0` | `10.4.0.29` | `255.255.255.252` | Link P2P ke Router12 Phantoma (Subnet A8) |
| **`Router12` (Phantoma)**| `Fa0/0` | `10.4.0.30` | `255.255.255.252` | Link P2P ke Router11 Knights (Subnet A8) |
| | `Fa0/1` | `10.4.0.65` | `255.255.255.224` | Gateway Switch8 (`Emi` - Subnet A13) |
| | `Fa1/0` | `10.4.0.33` | `255.255.255.252` | Link P2P ke Router13 Shibuya (Subnet A9) |
| **`Router13` (Shibuya)** | `Fa0/0` | `10.4.0.34` | `255.255.255.252` | Link P2P ke Router12 Phantoma (Subnet A9) |
| | `Fa0/1` | `10.4.1.65` | `255.255.255.192` | Gateway Switch12 (`Lain` & `Mika` - Subnet A17) |

---

## 6. Tabel Alokasi IP End-Devices (Host / Client / Server)

| Perangkat (Canvas) | Nama Karakter / Soal | Alamat IPv4 | Subnet Mask | Default Gateway |
| :--- | :--- | :--- | :--- | :--- |
| **`Server1`** | Karl (700 host) | `10.4.16.2` | `255.255.252.0` | `10.4.16.1` |
| **`Server2`** | Lin (180 host) | `10.4.16.3` | `255.255.252.0` | `10.4.16.1` |
| **`Laptop4`** | Masayuki (300 host) | `10.4.6.2` | `255.255.254.0` | `10.4.6.1` |
| **`Laptop3`** | Juri (31 host) | `10.4.0.130` | `255.255.255.192` | `10.4.0.129` |
| **`Server3`** | Akashic (3 host) | `10.4.0.50` | `255.255.255.248` | `10.4.0.49` |
| **`PC4`** | Omnipresence (510 host) | `10.4.12.2` | `255.255.252.0` | `10.4.12.1` |
| **`Laptop5`** | Denpa (3 host) | `10.4.12.3` | `255.255.252.0` | `10.4.12.1` |
| **`PC0`** | JJ (95 host) | `10.4.2.2` | `255.255.255.0` | `10.4.2.1` |
| **`Laptop0`** | MyuMyu (39 host) | `10.4.2.3` | `255.255.255.0` | `10.4.2.1` |
| **`PC1`** | Alice (208 host) | `10.4.4.2` | `255.255.255.0` | `10.4.4.1` |
| **`Laptop1`** | Reika (45 host) | `10.4.4.3` | `255.255.255.0` | `10.4.4.1` |
| **`PC2`** | Taro (57 host) | `10.4.1.2` | `255.255.255.192` | `10.4.1.1` |
| **`PC3`** | Yasuo (120 host) | `10.4.3.2` | `255.255.255.0` | `10.4.3.1` |
| **`Laptop2`** | Miho (18 host) | `10.4.3.3` | `255.255.255.0` | `10.4.3.1` |
| **`Server0`** | Kuma (4 host) | `10.4.3.4` | `255.255.255.0` | `10.4.3.1` |
| **`Server4`** | Collective (260 host) | `10.4.8.2` | `255.255.254.0` | `10.4.8.1` |
| **`PC6`** | Ghost (6 host) | `10.4.8.3` | `255.255.254.0` | `10.4.8.1` |
| **`Laptop6`** | Lilith (77 host) | `10.4.1.130` | `255.255.255.128` | `10.4.1.129` |
| **`PC7`** | Specter (21 host) | `10.4.1.131` | `255.255.255.128` | `10.4.1.129` |
| **`PC8`** | Chisa (23 host) | `10.4.0.194` | `255.255.255.192` | `10.4.0.193` |
| **`Laptop7`** | Hodgeson (9 host) | `10.4.0.195` | `255.255.255.192` | `10.4.0.193` |
| **`Server5`** | Eiri (2 host) | `10.4.0.58` | `255.255.255.248` | `10.4.0.57` |
| **`PC5`** | Emi (14 host) | `10.4.0.66` | `255.255.255.224` | `10.4.0.65` |
| **`Laptop108`** | Lain (57 host) | `10.4.1.66` | `255.255.255.192` | `10.4.1.65` |
| **`PC9`** | Mika (4 host) | `10.4.1.67` | `255.255.255.192` | `10.4.1.65` |

---

## 7. Dokumentasi & Konfigurasi CLI Router Cisco Packet Tracer

Setiap router dikonfigurasikan dengan menyetel alamat IP interface fisik, mengaktifkan link (`no shutdown`), serta menetapkan rute statis (*Static Routing*) dan *Default Gateway* menuju router pusat `Wired` dan gateway eksternal `Cyberia`.

Skrip konfigurasi lengkap untuk masing-masing router tersimpan rapi pada direktori [`scripts/`](scripts/):
* [`Router0_Cyberia.txt`](scripts/Router0_Cyberia.txt)
* [`Router1_Wired.txt`](scripts/Router1_Wired.txt)
* [`Router2_Tachibana.txt`](scripts/Router2_Tachibana.txt)
* [`Router3_Navi.txt`](scripts/Router3_Navi.txt)
* [`Router4_Psyche.txt`](scripts/Router4_Psyche.txt)
* [`Router5_Copland.txt`](scripts/Router5_Copland.txt)
* [`Router7_Schumann.txt`](scripts/Router7_Schumann.txt)
* [`Router8_Accela.txt`](scripts/Router8_Accela.txt)
* [`Router9_Deus.txt`](scripts/Router9_Deus.txt)
* [`Router10_Protocol7.txt`](scripts/Router10_Protocol7.txt)
* [`Router11_Knights.txt`](scripts/Router11_Knights.txt)
* [`Router12_Phantoma.txt`](scripts/Router12_Phantoma.txt)
* [`Router13_Shibuya.txt`](scripts/Router13_Shibuya.txt)

### Contoh Eksekusi CLI pada Router0 (Cyberia):
![CLI Cyberia](images/cli_router_cyberia.png)

```cisco
enable
configure terminal
hostname Cyberia

interface Fa0/0
 description Ke Cloud0
 ip address 10.4.89.246 255.255.255.0
 no shutdown

interface Fa0/1
 description Ke Switch0 (JJ & MyuMyu - Subnet A19)
 ip address 10.4.2.1 255.255.255.0
 no shutdown

interface Fa1/0
 description Ke Router1 (Subnet A1)
 ip address 10.4.0.1 255.255.255.252
 no shutdown

ip route 0.0.0.0 0.0.0.0 10.4.89.1
ip route 10.4.0.0 255.255.224.0 10.4.0.2
exit
write memory
```

---

## 8. Verifikasi Konektivitas & Pengujian Jaringan (Ping Test)

Setelah seluruh skrip konfigurasi diterapkan:
1. **Status Link Interface Fisik:**  
   Seluruh indikator lampu antarmuka pada router, switch, dan perangkat klien berubah menjadi **HIJAU** (link status *Up*).
   ![Bukti Indikator Hijau](images/bukti_konfigurasi_kiri.png)

2. **Pengujian ICMP (Ping Test):**
   * Menggunakan fitur simulasi **Simple PDU (Packet Data Unit)** dengan menekan tombol **`P`** pada keyboard.
   * Dilakukan uji konektivitas lintas cabang (misal dari `Laptop4` Masayuki di cabang barat menuju `PC1` Alice di cabang timur, serta menuju `Laptop108` Lain di ujung cabang selatan).
   * Seluruh pengujian menghasilkan status **`Successful`**, menandakan tabel routing statis telah bekerja secara optimal tanpa adanya *routing loop*.
