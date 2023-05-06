#   Name        Title       Accept      Cancel
set form {
    "clientes"  "Clientes"  "Aceptar"   "Cancelar"
}

#       Widget  Title/Name      Type        Width  Height   MinLen  MaxLen RegExp
set fields {
    {   label   "Código"                                                                }
    {   entry   id              integer     5       1       1       5       ""          }
    {   label   "Nombre"                                                                }
    {   entry   name            string      50      1       1       50      ""          }
    {   hrule                                                                           }
    {   label   "Dirección"                                                             }
    {   entry   street          string      50      1       0       50      ""          }
    {   label   "Cód. Postal"                                                           }
    {   entry   postcode        string      5       1       5       5       "^[0-9]*$"  }
    {   hrule                                                                           }
    {   label   "Teléfono"                                                              }
    {   entry   phone           string      50      1       0       50      ""          }
    {   label   "e-mail"                                                                }
    {   entry   email           string      50      1       0       255     ""          }
    {   label   "Notas"                                                                 }
    {   text    notes           string      50      2       0       50      ""          }
}

