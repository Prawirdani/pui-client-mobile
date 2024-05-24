class Menu {
  final int id;
  final String nama;
  final String deskripsi;
  final Kategori kategori;
  final int harga;
  final String url;

  Menu(this.id, this.nama, this.deskripsi, this.harga, this.url, this.kategori);
}

class Kategori {
  final int id;
  final String nama;
  Kategori(this.id, this.nama);
}
