set formName clientes
set formTitle "Clientes"

#       name           title           width minLength maxLength
set fields {
    {   id             "Código"        5       1       5       }
    {   name           "Nombre"        50      1       50      }
    {   street         "Dirección"     50      0       50      }
    {   postcode       "Cód. Postal"   5       0       50      }
    {   phone          "Teléfono"      50      0       50      }
    {   email          "e-mail"        50      0       255     }
}

set acceptTitle "Aceptar"
set cancelTitle "Cancelar"

