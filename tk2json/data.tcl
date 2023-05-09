set formName clientes

#       Widget  Text/Name    Type/Command   Width  Height   Min|MaxLength   RegExp      Flags
set form {
    {   title   "Clientes"                                                              {}                  }
    {   label   "Código"                                                                {}                  }
    {   entry   codigo          integer     5       1       1       5       "^[0-9]*$"  {justify:center}    }
    {   label   "Nombre"                                                                {}                  }
    {   entry   nombre          string      50      1       1       50      ""          {}                  }
    {   hrule                                                                           {}                  }
    {   label   "Dirección"                                                             {}                  }
    {   entry   direccion       string      0       1       0       50      ""          {}                  }
    {   label   "Población"                                                             {}                  }
    {   pack                                                                            {}                  }
    {   entry   codpostal       string      5       1       5       5       "^[0-9]*$"  {justify:center}    }
    {   entry   poblacion       string      0       1       0       50      ""          {}                  }
    {   pack                                                                            {}                  }
    {   label   "Provincia"                                                             {}                  }
    {   pack                                                                            {}                  }
    {   entry   provincia       string      0       1       0       50      ""          {}                  }
    {   label   "País"                                                                  {}                  }
    {   entry   pais            string      0       1       0       50      ""          {}                  }
    {   pack                                                                            {}                  }
    {   hrule                                                                           {}                  }
    {   label   "Teléfono"                                                              {}                  }
    {   pack                                                                            {}                  }
    {   entry   telefono1       string      0       1       0       50      ""          {}                  }
    {   entry   telefono2       string      0       1       0       50      ""          {}                  }
    {   pack                                                                            {}                  }
    {   label   "E-Mail"                                                                {}                  }
    {   entry   email           string      0       1       0       255     ""          {}                  }
    {   hrule                                                                           {}                  }
    {   label   "Notas"                                                                 {}                  }
    {   text    notas           string      0       4       0       255     ""          {}                  }
    {   hrule                                                                           {}                  }
    {   pack                                                                            {align:right}       }
    {   button  "Aceptar"       onAccept                                                {}                  }
    {   button  "Cancelar"      onCancel                                                {}                  }
    {   pack                                                                            {}                  }
}

