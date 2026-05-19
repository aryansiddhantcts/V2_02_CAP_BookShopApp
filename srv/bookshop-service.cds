using my.bookshop as db from '../db/bookshop-schema';

@path: '/book-shop-app'
service myservice {

  @Capabilities.DeleteRestrictions.Deletable  : true
  @Capabilities.InsertRestrictions.Insertable : true
  @Capabilities.UpdateRestrictions.Updatable  : true

  @UI.CreateHidden : false
  @UI.DeleteHidden : false
  @UI.UpdateHidden : false

  //@odata.draft.enabled: true

  // ──1.0 List Page Columns: Enable navigatio ───────────────────────────────────────────────────────
  @UI.LineItem: [
    { Value: bookid,      Label: 'Book ID'            },
    { Value: title,       Label: 'Book Name'          },
    { Value: genre,       Label: 'Genre'              },
    { Value: publCountry, Label: 'Publishing Country' },
    { Value: stock,       Label: 'Stock'              },
    { Value: isHardcover, Label: 'Hardcover'          }
  ]

  // ──2.1 Header Info ─────────────────────────────────────────────────────────────
  @UI.HeaderInfo: {
    TypeName      : 'Book',
    TypeNamePlural: 'Books',
    Title         : { Value: bookid },
    Description   : { Value: title }
  }

  // ──2.2 Header Section — shown at top of detail page ───────────────────────────
  @UI.HeaderFacets: [
    {
      $Type  : 'UI.ReferenceFacet',
      Label  : 'Key Information Header Facet',
      Target : '@UI.FieldGroup#Header'
    }
  ]
  @UI.FieldGroup #Header: {
    Data: [
      { Value: bookid,      Label: 'Book ID'            },
      { Value: title,       Label: 'Book Name'          }
    ]
  }


  // ──3.1 Detail Sections — tabs on the object page ───────────────────────────────
  @UI.Facets: [
    {
      $Type  : 'UI.ReferenceFacet',
      Label  : 'Book Details',
      Target : '@UI.FieldGroup#Details'
    },
    {
      $Type  : 'UI.ReferenceFacet',
      Label  : 'Pricing & Stock',
      Target : '@UI.FieldGroup#Pricing'
    },
    {
      $Type  : 'UI.ReferenceFacet',
      Label  : 'Additional Info',
      Target : '@UI.FieldGroup#Additional'
    }
  ]

  // ──3.2 Detail Section 1 — Book Details ────────────────────────────────────────
  @UI.FieldGroup #Details: {
    Data: [
      { Value: bookid,      Label: 'Book ID'            },
      { Value: title,       Label: 'Book Name'          },
      { Value: genre,       Label: 'Genre'              },
      { Value: publCountry, Label: 'Publishing Country' }
    ]
  }

  // ── Detail Section 2 — Pricing & Stock ─────────────────────────────────────
  @UI.FieldGroup #Pricing: {
    Data: [
      { Value: price_amount,   Label: 'Price Amount'   },
      { Value: price_currency, Label: 'Price Currency' },
      { Value: stock,          Label: 'Stock'          },
      { Value: isHardcover,    Label: 'Hardcover'      }
    ]
  }

  // ── Detail Section 3 — Additional Info ─────────────────────────────────────
  @UI.FieldGroup #Additional: {
    Data: [
      { Value: createdAt,  Label: 'Created On'  },
      { Value: createdBy,  Label: 'Created By'  },
      { Value: modifiedAt, Label: 'Changed On'  },
      { Value: modifiedBy, Label: 'Changed By'  }
    ]
  }

  // ── Entity Projection ───────────────────────────────────────────────────────
  //@odata.draft.enabled: true
  entity Books as projection on db.Books {
    *,
    ID @UI.Hidden
  }

}
