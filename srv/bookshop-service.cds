using my.bookshop as db from '../db/bookshop-schema';

@path: '/book-shop-app'
service myservice {
    entity Books   as
        projection on db.Books {
            *,
            null as priceFormatted : String  @title: 'Formatted Price'  @Core.Computed,
            null as genreLabel     : String  @title: 'Genre Label'      @Core.Computed,
            // @Core.Computed tells CAP: Don't include in INSERT/UPDATE,Don't try to persist in draft table,Value is always computed at read time
            ID                               @UI.Hidden
        }

    entity Authors as projection on db.Authors;

    //@readonly
    entity Epochs  as projection on db.Epochs;
//CAP auto-generates value help only when the association target has a @cds.autoexpose or is explicitly annotated.
}

// ═══════════════════════════════════════════════════════════════════════════
// BOOKS annotations — completely separate from Authors
// ═══════════════════════════════════════════════════════════════════════════
// annotate myservice.Books with {
//     author @(
//         Common.Text           : author.name,
//         Common.TextArrangement: #TextOnly,
//         Common.ValueList      : {
//             CollectionPath: 'Authors',
//             Parameters    : [
//                 {
//                     $Type             : 'Common.ValueListParameterOut',
//                     LocalDataProperty : author_ID,
//                     ValueListProperty : 'ID'
//                 },
//                 {
//                     $Type             : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty : 'name'
//                 }
//             ]
//         }
//     )
// };
annotate myservice.Books with @(
    Capabilities.DeleteRestrictions.Deletable : true,
    Capabilities.InsertRestrictions.Insertable: true,
    Capabilities.UpdateRestrictions.Updatable : true,
    UI.CreateHidden                           : false,
    UI.DeleteHidden                           : false,
    UI.UpdateHidden                           : false,
    odata.draft.enabled                       : true,
    UI.LineItem                               : [
        {
            Value: bookid, // CHECK FROM PAYLOAD
            Label: 'Book ID'
        },
        {
            Value: title,
            Label: 'Book Name'
        },
        {
            Value: author_ID,
            Label: 'Author'
        },
        {
            Value: genre,
            Label: 'Genre'
        },
        {
            Value: publCountry_code, // CHECK FROM PAYLOAD
            Label: 'Publishing Country'
        },
        {
            Value: stock,
            Label: 'Stock'
        },
        {
            Value: price_amount,
            Label: 'Price Amount'
        },
        {
            Value: price_currency_code, // CHECK FROM PAYLOAD
            Label: 'Price Currency'
        },
        {
            Value: priceFormatted,
            Label: 'Formatted Price'
        },
        {
            Value: genreLabel,
            Label: 'Genre Label'
        },
        {
            Value: isHardcover,
            Label: 'Hardcover'
        }
    ],

    UI.HeaderInfo                             : {
        TypeName      : 'Book',
        TypeNamePlural: 'Books',
        Title         : {Value: title},
        Description   : {Value: author_ID}
    },

    UI.HeaderFacets                           : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Key Information',
        Target: '@UI.FieldGroup#BookHeader'
    }],

    UI.FieldGroup #BookHeader                 : {Data: [
        {
            Value: bookid,
            Label: 'Book ID'
        },
        {
            Value: title,
            Label: 'Book Name'
        }
    ]},

    UI.Facets                                 : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Book Details',
            Target: '@UI.FieldGroup#BookDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Author Details',
            Target: '@UI.FieldGroup#BookAuthor'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Pricing & Stock',
            Target: '@UI.FieldGroup#BookPricing'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Additional Info',
            Target: '@UI.FieldGroup#BookAdditional'
        }
    ],

    UI.FieldGroup #BookDetails                : {Data: [
        {
            Value: bookid,
            Label: 'Book ID'
        },
        {
            Value: title,
            Label: 'Book Name'
        },
        {
            Value: genre,
            Label: 'Genre'
        },
        {
            Value: publCountry_code,
            Label: 'Publishing Country'
        }
    ]},

    UI.FieldGroup #BookAuthor                 : {Data: [
        {
            Value: author_ID,
            Label: 'Author ID'
        },
        {
            Value: author.dateOfBirth,
            Label: 'Date of Birth'
        },
        {
            Value: author.dateOfDeath,
            Label: 'Date of Death'
        }
    ]},

    UI.FieldGroup #BookPricing                : {Data: [
        {
            Value: price_amount,
            Label: 'Price Amount'
        },
        {
            Value: price_currency_code, // CHECK FROM PAYLOAD
            Label: 'Price Currency'
        },
        {
            Value: stock,
            Label: 'Stock'
        },
        {
            Value: isHardcover,
            Label: 'Hardcover'
        }
    ]},

    UI.FieldGroup #BookAdditional             : {Data: [
        {
            Value: createdAt,
            Label: 'Created On'
        },
        {
            Value: createdBy,
            Label: 'Created By'
        },
        {
            Value: modifiedAt,
            Label: 'Changed On'
        },
        {
            Value: modifiedBy,
            Label: 'Changed By'
        }
    ]}
) {
    author @(
        Common.Text           : author.name,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            CollectionPath: 'Authors',
            //--> book-shop-app/Authors
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: author_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        }
    )
};

// ═══════════════════════════════════════════════════════════════════════════
// AUTHORS annotations — completely separate from Books
// ═══════════════════════════════════════════════════════════════════════════
annotate myservice.Authors with @(
    Capabilities.DeleteRestrictions.Deletable : true,
    Capabilities.InsertRestrictions.Insertable: true,
    Capabilities.UpdateRestrictions.Updatable : true,
    UI.CreateHidden                           : false,
    UI.DeleteHidden                           : true,
    UI.UpdateHidden                           : false,
    odata.draft.enabled                       : true,
    UI.LineItem                               : [
        {
            Value: name,
            Label: 'Author Name'
        },
        {
            Value: dateOfBirth,
            Label: 'Date of Birth'
        },
        {
            Value: dateOfDeath,
            Label: 'Date of Death'
        },
        {
            Value: epoch_ID, // CHECK FROM PAYLOAD as one to one association
            Label: 'Epoch ID'
        },
        {
            Value: epoch.name, // ASSOCIATION TO EPOCHS
            Label: 'Epoch name'
        },
    ],

    UI.HeaderInfo                             : {
        TypeName      : 'Author',
        TypeNamePlural: 'Authors',
        Title         : {Value: name},
        Description   : {Value: dateOfBirth}
    },

    UI.HeaderFacets                           : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Birth Details',
        Target: '@UI.FieldGroup#AuthorHeader'
    }],

    UI.FieldGroup #AuthorHeader               : {Data: [
        {
            Value: dateOfBirth,
            Label: 'Date of Birth'
        },
        {
            Value: dateOfDeath,
            Label: 'Date of Death'
        }
    ]},

    UI.Facets                                 : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Author Details',
            Target: '@UI.FieldGroup#AuthorDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Published Books',
            Target: 'books/@UI.LineItem' // Navigate to associated Books and use the LineItem annotation defined there
        }
    ],

    UI.FieldGroup #AuthorDetails              : {Data: [
        {
            Value: ID,
            Label: 'Author ID'
        },
        {
            Value: name,
            Label: 'Author Name'
        },
        {
            Value: dateOfBirth,
            Label: 'Date of Birth'
        },
        {
            Value: dateOfDeath,
            Label: 'Date of Death'
        },
        {
            Value: epoch.name,
            Label: 'Epoch name'
        },
        {
            Value: epoch_ID,
            Label: 'Epoch ID'
        }
    ]},
    UI.QuickViewFacets                        : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Author Info',
        Target: '@UI.FieldGroup#AuthorQuickView'
    }],

    UI.FieldGroup #AuthorQuickView            : {Data: [
        {
            Value: name,
            Label: 'Author Name'
        },
        {
            Value: dateOfBirth,
            Label: 'Date of Birth'
        },
        {
            Value: dateOfDeath,
            Label: 'Date of Death'
        }
    ]}

);
