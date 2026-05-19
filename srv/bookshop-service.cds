using my.bookshop as db from '../db/bookshop-schema';

@path: '/book-shop-app'
service myservice {
    //entity Authors as projection on db.Authors;
    entity Books as
        projection on db.Books {
            *
        }
}
// @path: '/bookshop'
// service operations {
//     function getBooksByGenre(genre: Integer) returns String;
//     action buyBook(bookID: String) returns Boolean;
// }
