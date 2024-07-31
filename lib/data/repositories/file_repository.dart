import '../models/book_model.dart';

class BookRepository {
  List<BookModel> books = [
    BookModel(
      title: "Utgan Kunlar",
      bookUrl:
          "https://docenti.unimc.it/antonella.pascali/teaching/2018/19055/files/ultima-lezione/harry-potter-and-the-philosophers-stone",
      coverageUrl:
          "https://images.uzum.uz/cltlles6pk58gtm6g7p0/original.jpg",
      savePath: "",
      progress: 0,
      isLoading: false,
      isDownloaded: false,
    ),
    BookModel(
      title: "Utgan Kunlar 2",
      bookUrl:
          "https://namdu.uz/books/84%20Badiy%20adabyot%20asarlar/a_qodiriyt_utgan_kunlar_namdu_uz.pdf",
      coverageUrl:
          "https://i.ytimg.com/vi/Uqr-nRPIhks/mqdefault.jpg",
      savePath: "",
      progress: 0,
      isLoading: false,
      isDownloaded: false,
    ),
    BookModel(
      title: "Harry Potter 3",
      bookUrl:
          "https://vidyaprabodhinicollege.edu.in/VPCCECM/ebooks/ENGLISH%20LITERATURE/Harry%20potter/(Book%203)%20Harry%20Potter%20And%20The%20Prisoner%20Of%20Azkaban_001.pdf",
      coverageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1w9Sug7kJoGENfm75E2KsC86LgtA9rwxTpg&s",
      savePath: "",
      progress: 0,
      isLoading: false,
      isDownloaded: false,
    ),
  ];
}
