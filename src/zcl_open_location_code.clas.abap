CLASS zcl_open_location_code DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_open_location_code_point .

    "! Various initial setups
    CLASS-METHODS class_constructor .
    "! Returns the encoding alphabet.
    CLASS-METHODS get_alphabet
      RETURNING
        VALUE(result) TYPE string .
    "! Determines if a code is a valid Open Location Code.
    "!
    "! @parameter code | The code to be evaluated
    "! @parameter result | true, false
    METHODS is_valid
      IMPORTING
        !code         TYPE string
      RETURNING
        VALUE(result) TYPE xsdboolean .
    "! Determines if a code is a valid short Open Location Code.
    "!
    "! @parameter code | The code to be evaluated
    "! @parameter result | true, false
    METHODS is_short
      IMPORTING
        !code         TYPE string
      RETURNING
        VALUE(result) TYPE xsdboolean .
    "! Determine if a code is a valid full Open Location Code.
    "!
    "! @parameter code | The code to be evaluated
    "! @parameter result | true, false
    METHODS is_full
      IMPORTING
        !code         TYPE string
      RETURNING
        VALUE(result) TYPE xsdboolean .
    "! Encode a location ( a latitude / longitude ) into an Open Location Code
    "!
    "! @parameter pt | Point described by a latitude and longitude
    "! @parameter code_length | Desired code length
    "! @parameter result | Resulting code
    METHODS encode
      IMPORTING
        !pt           TYPE zif_open_location_code_point~ty_point
        !code_length  TYPE i DEFAULT 10
      RETURNING
        VALUE(result) TYPE string .
    "! Decodes an Open Location Code into a bounding box representing the code area.
    "!
    "! @parameter code |
    "! @parameter result |
    "! @raising CX_OLC_ERROR |
    METHODS decode
      IMPORTING
        VALUE(code)   TYPE string
      RETURNING
        VALUE(result) TYPE REF TO zcl_open_location_code_area
      RAISING
        zcx_open_location_code .
    "! Shortens an Open Location Code by removing characters from the start of a given code.
    "!
    "! @parameter code |
    "! @parameter ref_pt |
    "! @parameter result |
    METHODS shorten
      IMPORTING
        VALUE(code)   TYPE string
        !ref_pt       TYPE zif_open_location_code_point=>ty_point
      RETURNING
        VALUE(result) TYPE string .
    "! Recover the nearest matching full Open Location Code to a specified location.
    "!
    "! @parameter shortcode |
    "! @parameter ref_pt |
    "! @parameter result |
    METHODS recover_nearest
      IMPORTING
        VALUE(shortcode) TYPE string
        !ref_pt          TYPE zif_open_location_code_point~ty_point
      RETURNING
        VALUE(result)    TYPE string .
  PRIVATE SECTION.

    ALIASES point
      FOR zif_open_location_code_point~ty_point .

    TYPES:
      " The resolution values in degrees for each position in the latitude/longitude pair
      " encoding. These give the place value of each position, and therefore the
      " dimensions of the resulting area.
      BEGIN OF resolution_value_type,
        resolution TYPE decfloat34.
    TYPES END OF resolution_value_type .
    TYPES:
      BEGIN OF alphabet_type,
        char  TYPE c LENGTH 1,
        index TYPE i.
    TYPES: END OF alphabet_type .

    CONSTANTS:
      " A separator used to break the code into two parts to aid memorability.
      separator TYPE c LENGTH 1 VALUE '+' ##NO_TEXT.
    " The number of characters to place before the separator.
    CONSTANTS separator_position TYPE i VALUE 8 ##NO_TEXT.
    CONSTANTS:
      " The character used to pad codes.
      padding_char TYPE c LENGTH 1 VALUE '0' ##NO_TEXT.
    CONSTANTS:
      " The character set used to encode the values.
      code_alphabet TYPE c LENGTH 20 VALUE '23456789CFGHJMPQRVWX' ##NO_TEXT.
    CONSTANTS:
      " The encoding alphabet with separator.
      code_alphabet_with_sep TYPE c LENGTH 21 VALUE '23456789CFGHJMPQRVWX+' ##NO_TEXT.
    CONSTANTS:
      " The encoding alphabet with separator and padding character.
      code_with_sep_and_padd TYPE c LENGTH 22 VALUE '23456789CFGHJMPQRVWX+0' ##NO_TEXT.
    " The base used for encoding and decoding numbers.
    CONSTANTS encoding_base TYPE int8 VALUE 20 ##NO_TEXT.
    " The maximum value for latitude in degrees.
    CONSTANTS latitude_max TYPE int8 VALUE 90 ##NO_TEXT.
    " The minimum value for latitude in degrees.
    CONSTANTS latitude_min TYPE int8 VALUE -90 ##NO_TEXT.
    " The maximum value for longitude in degrees.
    CONSTANTS longitude_max TYPE int8 VALUE 180 ##NO_TEXT.
    " The minimum value for longitude in degrees.
    CONSTANTS longitude_min TYPE int8 VALUE -180 ##NO_TEXT.
    " Maximum number of digits to process for plus codes.
    CONSTANTS max_code_length TYPE i VALUE 15 ##NO_TEXT.
    " Maximum code length using latitude/longitude pair encoding. The area of such a
    " code is approximately 13x13 meters (at the equator), and should be suitable
    " for identifying buildings. The code length excludes prefix and separator characters.
    CONSTANTS pair_code_length TYPE i VALUE 10 ##NO_TEXT.
    " Digits in the grid encoding segment.
    CONSTANTS grid_code_length TYPE i VALUE 5 ##NO_TEXT.
    CLASS-DATA:
      resolution_values TYPE STANDARD TABLE OF resolution_value_type .
    " Number of columns in the grid refinement method.
    CONSTANTS grid_columns TYPE int8 VALUE 4 ##NO_TEXT.
    " Number of rows in the grid refinement method.
    CONSTANTS grid_rows TYPE int8 VALUE 5 ##NO_TEXT.
    " Minimum length of a code that can be shortened.
    CONSTANTS min_trimmable_code_len TYPE int8 VALUE 6 ##NO_TEXT.
    " Value to subtract from maximum latitude to allow decoding
    CONSTANTS lat_difference TYPE decfloat34 VALUE '0.0000000001' ##NO_TEXT.
    " What to multiple latitude degrees by to get an integer value. There are three pairs representing
    " decimal digits, and five digits in the grid.
    " Value calculated in class constructor
    CLASS-DATA lat_integer_multiplier TYPE int8 .
    " What to multiple longitude degrees by to get an integer value. There are three pairs representing
    " decimal digits, and five digits in the grid.
    " Value calculated in class constructor
    CLASS-DATA lng_integer_multiplier TYPE int8 .
    CLASS-DATA:
      alphabet_codes TYPE SORTED TABLE OF alphabet_type WITH UNIQUE KEY char .

    "! Determines the value of a given encoding character
    "!
    "! @parameter code |
    "! @parameter result |
    METHODS code_value
      IMPORTING
        !code         TYPE c
      RETURNING
        VALUE(result) TYPE i .
    "! Normalize a longitude value
    "!
    "! @parameter value |
    "! @parameter result |
    METHODS normalize_longitude
      IMPORTING
        !value        TYPE decfloat34
      RETURNING
        VALUE(result) TYPE decfloat34 .
    "! Clip a latitude
    "!
    "! @parameter latitude_degrees |
    "! @parameter result |
    METHODS clip_latitude
      IMPORTING
        !latitude_degrees TYPE decfloat34
      RETURNING
        VALUE(result)     TYPE decfloat34 .
    "! Compute latitude precision
    "!
    "! @parameter code_length |
    "! @parameter result |
    METHODS compute_latitude_precision
      IMPORTING
        !code_length  TYPE i
      RETURNING
        VALUE(result) TYPE decfloat34 .
    "! Define the alphabet of encoding characters
    "!
    CLASS-METHODS define_alphabet .
    CLASS-METHODS define_resolutions .
ENDCLASS.



CLASS ZCL_OPEN_LOCATION_CODE IMPLEMENTATION.


  METHOD class_constructor.

    define_alphabet( ).

    lat_integer_multiplier = encoding_base
         * encoding_base
         * encoding_base
         * grid_rows
         * grid_rows
         * grid_rows
         * grid_rows
         * grid_rows .

    lng_integer_multiplier = encoding_base
         * encoding_base
         * encoding_base
         * grid_columns
         * grid_columns
         * grid_columns
         * grid_columns
         * grid_columns .

    define_resolutions( ).

  ENDMETHOD.


  METHOD clip_latitude.

    result = latitude_degrees.

    IF latitude_degrees > latitude_max .
      result = latitude_max.
    ENDIF.
    IF latitude_degrees < latitude_min .
      result = latitude_min.
    ENDIF.

  ENDMETHOD.


  METHOD code_value.


    READ TABLE alphabet_codes INTO DATA(alphabet_code) WITH KEY char = code .
    IF sy-subrc <> 0.
      ASSERT 0 = 1 .
    ENDIF.
    result = alphabet_code-index.

  ENDMETHOD.


  METHOD compute_latitude_precision.

* https://github.com/google/open-location-code/blob/master/docs/specification.md#code-precision

* Length  Lat                           Long
* 2       20          20^1            x 20                   20^1
* 4       1           20^0            x 1                    20^0
* 6       0.05        20^1-           x 0.05                 20^1-
* 8       0.0025      20^2-           x 0.0025               20^2-
* 10      0.000125    20^3-           x 0.000125             20^3-
* 11      0.000025    1/( 20^3 * 5 )  x 0.00003125           1/( 20^3 * 4 )   (1/32000)
* 12      0.000005    1/( 20^3 * 5^2) x 0.0000078125         1/( 20^3 * 4^2 ) (1/128000)
* 13      0.000001    1/( 20^3 * 5^3) x 0.000001953125       1/( 20^3 * 4^3 ) (1/512000)
* 14      0.0000002   1/( 20^3 * 5^4) x 0.00000048828125     1/( 20^3 * 4^4 ) (1/2048000)
* 15      0.00000004  1/( 20^3 * 5^5) x 0.0.0000001220703125 1/( 20^3 * 4^5)  (1/8192000)

    IF code_length <= pair_code_length.
      result = encoding_base ** ( floor( code_length / '-2.0' + '2.0' )  ).
    ELSE.
      result = (  encoding_base ** -3 ) / ( '1.0' * grid_rows ** ( code_length - pair_code_length )  ) .
    ENDIF.

  ENDMETHOD.


  METHOD decode.
* https://github.com/google/open-location-code/blob/master/docs/specification.md#code-precision

* Length  Lat                           Long
* 2       20          20^1            x 20                   20^1
* 4       1           20^0            x 1                    20^0
* 6       0.05        20^1-           x 0.05                 20^1-
* 8       0.0025      20^2-           x 0.0025               20^2-
* 10      0.000125    20^3-           x 0.000125             20^3-
* 11      0.000025    1/( 20^3 * 5 )  x 0.00003125           1/( 20^3 * 4 )   (1/32000)
* 12      0.000005    1/( 20^3 * 5^2) x 0.0000078125         1/( 20^3 * 4^2 ) (1/128000)
* 13      0.000001    1/( 20^3 * 5^3) x 0.000001953125       1/( 20^3 * 4^3 ) (1/512000)
* 14      0.0000002   1/( 20^3 * 5^4) x 0.00000048828125     1/( 20^3 * 4^4 ) (1/2048000)
* 15      0.00000004  1/( 20^3 * 5^5) x 0.0.0000001220703125 1/( 20^3 * 4^5)  (1/8192000)


    IF is_full( code ) = abap_true.

      "// Strip padding and separators and all to upper case.
      REPLACE ALL OCCURRENCES OF  separator        IN code WITH '' IN CHARACTER MODE.
      REPLACE ALL OCCURRENCES OF  padding_char IN code WITH '' IN CHARACTER MODE.
      code = to_upper( code ).

      "// Length of remaining code?
      DATA(numchars) = numofchar( code ) .

      "// If code is too long, truncate it
      IF numchars >  max_code_length.
        code = substring( val = code
                          off = 0
                          len =  max_code_length ) .
        "// Length of remaining code?
        numchars = numofchar( code ) .
      ENDIF.

      "// Work out the values as integers and convert to floating point at the end.


      DATA(lat) = -90 *  lat_integer_multiplier  .
      DATA(lng) = -180 *  lng_integer_multiplier .


      DATA(lat_place_value) =  lat_integer_multiplier * ipow( base =  encoding_base
                                                        exp = 2 ) .
      DATA(lng_place_value) =  lng_integer_multiplier * ipow( base =  encoding_base
                                                        exp = 2 ) .
      DATA chr TYPE c.
      DO numchars TIMES.

        DATA(idx) = ( sy-index - 1 ) .

        chr = code+idx(1) .

        IF idx <  pair_code_length .

          IF idx MOD 2 = 0.
            lat_place_value = lat_place_value /  encoding_base .
            lat = lat + lat_place_value * code_value( chr ) .
          ELSE.
            lng_place_value = lng_place_value /  encoding_base .
            lng = lng + lng_place_value * code_value( chr ) .
          ENDIF.

        ELSE.

          lat_place_value = lat_place_value /  grid_rows    .
          lng_place_value = lng_place_value /  grid_columns .

          DATA(intermediate) = ( code_value( chr ) DIV  grid_columns ).
          lat = lat + lat_place_value * ( code_value( chr ) DIV  grid_columns ) .
          lng = lng + lng_place_value * ( code_value( chr ) MOD  grid_columns ) .

        ENDIF.

      ENDDO.

      " Convert to floating point values

      " Integer to float
      DATA lat_lo TYPE decfloat34.
      lat_lo = lat .

      " Float math
      lat_lo = ( lat_lo ) /  lat_integer_multiplier .


      " Integer to float
      DATA lng_lo TYPE decfloat34.
      lng_lo = lng .
      " Float math
      lng_lo = ( lng_lo ) /  lng_integer_multiplier .


      " Integer to float
      DATA lat_hi TYPE decfloat34.
      lat_hi = lat.

      " Float addition
      lat_hi = lat_hi + lat_place_value .
      lat_hi = lat_hi / ( ( ipow( base =  encoding_base
                                  exp = 3 ) * ipow( base =  grid_rows
                                                                          exp = 5 ) ) )  .


      " Integer to float
      DATA lng_hi TYPE decfloat34.
      lng_hi = lng.
      " Float addition
      lng_hi = lng_hi + lng_place_value .
      lng_hi = lng_hi  / ( ( ipow( base =  encoding_base
                                   exp = 3 ) * ipow( base =  grid_columns
                                                                           exp = 5 ) ) ) .

      "// We always pass in the maximum resolution and expect the code area to truncate based upon code_length
      result =  zcl_open_location_code_area=>create(
                  south       = lat_lo
                  west        = lng_lo
                  north       = lat_hi
                  east        = lng_hi
                  code_length = numchars )  .

    ELSE.

      RAISE EXCEPTION TYPE zcx_open_location_code.

    ENDIF.


  ENDMETHOD.


  METHOD define_alphabet.

    DATA alphabet_code LIKE LINE OF alphabet_codes.

    alphabet_code-char  = '2'.
    alphabet_code-index = 0.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '3'.
    alphabet_code-index = 1.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '4'.
    alphabet_code-index = 2.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '5'.
    alphabet_code-index = 3.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '6'.
    alphabet_code-index = 4.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '7'.
    alphabet_code-index = 5.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '8'.
    alphabet_code-index = 6.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = '9'.
    alphabet_code-index = 7.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'C'.
    alphabet_code-index = 8.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'F'.
    alphabet_code-index = 9.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'G'.
    alphabet_code-index = 10.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'H'.
    alphabet_code-index = 11.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'J'.
    alphabet_code-index = 12.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'M'.
    alphabet_code-index = 13.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'P'.
    alphabet_code-index = 14.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'Q'.
    alphabet_code-index = 15.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'R'.
    alphabet_code-index = 16.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'V'.
    alphabet_code-index = 17.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'W'.
    alphabet_code-index = 18.
    INSERT alphabet_code INTO TABLE alphabet_codes.
    alphabet_code-char  = 'X'.
    alphabet_code-index = 19.
    INSERT alphabet_code INTO TABLE alphabet_codes.

  ENDMETHOD.


  METHOD define_resolutions.
    FIELD-SYMBOLS <line> TYPE resolution_value_type.
    APPEND INITIAL LINE TO resolution_values ASSIGNING <line>.
    <line>-resolution = '20.0'.
    APPEND INITIAL LINE TO resolution_values ASSIGNING <line>.
    <line>-resolution = '1.0'.
    APPEND INITIAL LINE TO resolution_values ASSIGNING <line>.
    <line>-resolution = '0.05'.
    APPEND INITIAL LINE TO resolution_values ASSIGNING <line>.
    <line>-resolution = '0.0025'.
    APPEND INITIAL LINE TO resolution_values ASSIGNING <line>.
    <line>-resolution = '0.000125'.

  ENDMETHOD.


  METHOD encode.
*/// Encode a location into an Open Location Code.
*///
*/// Produces a code of the specified length, or the default length if no
*/// length is provided.
*/// The length determines the accuracy of the code. The default length is
*/// 10 characters, returning a code of approximately 13.5x13.5 meters. Longer
*/// codes represent smaller areas, but lengths > 14 are sub-centimetre and so
*/// 11 or 12 are probably the limit of useful codes.

    DATA code TYPE string.

    DATA(trimmed_code_length) = code_length.
    IF trimmed_code_length >  max_code_length.
      trimmed_code_length =  max_code_length.
    ENDIF.

    DATA(lat) = clip_latitude( pt-lat ).
    DATA(lng) = normalize_longitude( pt-lng ).

    "// Latitude 90 needs to be adjusted to be just less, so the returned code
    "// can also be decoded.
    IF lat >  latitude_max OR ( (  latitude_max - lat ) <  lat_difference ) .
      lat = lat - compute_latitude_precision( trimmed_code_length ) .
    ENDIF.


* Compute the code.

    DATA lat_val TYPE int8.
    DATA lng_val TYPE int8.

    "// Convert to integers.
    lat_val = floor( round( val = ( ( lat +  latitude_max ) *  lat_integer_multiplier )
                            dec = 8
                            mode = cl_abap_math=>round_half_up ) ) .

    lng_val = floor( round( val = ( ( lng +  longitude_max ) *  lng_integer_multiplier )
                            dec = 8
                            mode = cl_abap_math=>round_half_up ) ) .

*  Compute the code
    "// This largely ignores the requested length - it
    "//  generates either a 10 digit code, or a 15 digit code, and then truncates
    "// it to the requested length.


    "// Compute the grid part of the code if necessary
    " JS around 351

    DATA rev_code TYPE string.
    DATA lat_digit TYPE int8.
    DATA lng_digit TYPE int8.
    DATA ndx TYPE i.
    DATA this_code TYPE c LENGTH 1.
    DATA i TYPE i.

    IF trimmed_code_length >  pair_code_length .
      i = 0.
      WHILE i <  grid_code_length.
        lat_digit = lat_val MOD  grid_rows.
        lng_digit = lng_val MOD  grid_columns.
        ndx = ( lat_digit *  grid_columns + lng_digit ) .
        this_code =  code_alphabet+ndx(1).
        rev_code = rev_code && this_code.
        lat_val = floor( ( lat_val * '1.00000000000' ) /  grid_rows    ).
        lng_val = floor( ( lng_val * '1.00000000000' ) /  grid_columns ).
        i = i + 1.
      ENDWHILE.
    ELSE.
      "// Adjust latitude and longitude values to skip the grid digits.
      lat_val = floor( ( lat_val * '1.000000000' ) / (  grid_rows    **  grid_code_length ) ) .
      lng_val = floor( ( lng_val * '1.000000000' ) / (  grid_columns **  grid_code_length ) ) .
    ENDIF.

    rev_code = reverse( rev_code ).
    "// Compute the pair section of the code.
    i = 0.
    ndx = 0.
    WHILE i < (  pair_code_length / 2 ) .
      ndx = lng_val MOD  encoding_base .

      rev_code =   code_alphabet+ndx(1) && rev_code.

      ndx = lat_val MOD  encoding_base .
      rev_code =  code_alphabet+ndx(1) && rev_code.

      lat_val = floor( ( lat_val * '1.0000000000' ) /  encoding_base ) .
      lng_val = floor( ( lng_val * '1.0000000000' ) /  encoding_base ) .
      IF i = 0 .
        rev_code =  separator && rev_code.
      ENDIF.
      i = i + 1 .
    ENDWHILE.

    "// Add the separator character


    IF trimmed_code_length <  separator_position.

      rev_code  = substring( val = rev_code
                             off = 0
                             len = trimmed_code_length ).

      DO (  separator_position - trimmed_code_length ) TIMES.
        rev_code = rev_code &&  padding_char.
      ENDDO.

      result  = rev_code &&  separator.

    ELSE.
      result  = substring( val = rev_code
                           off = 0
                           len = trimmed_code_length + 1 ).
    ENDIF.

  ENDMETHOD.


  METHOD get_alphabet.

    result =  code_alphabet.

  ENDMETHOD.


  METHOD is_full.


    IF is_valid( code ) = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.

    IF is_short( code ) = abap_true.
      result = abap_false.
      RETURN.
    ENDIF.


    " JavaScript adds additional checks here which Rust does not implement.
    result = abap_true.


  ENDMETHOD.


  METHOD is_short.

    IF is_valid( code ) = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.

    DATA(offset) = find( val = code
                         sub =  separator ) .

    IF ( offset <  separator_position ) AND ( offset >= 0 ) .
      result = abap_true.
      RETURN.
    ELSE.
      result = abap_false.
      RETURN.
    ENDIF.


  ENDMETHOD.


  METHOD is_valid.

    result = abap_false.

    "// The separator is required.
    IF count( val = code
              sub =  separator ) = 0.
      RETURN.
    ENDIF.

    "// Minimum code length
    IF numofchar( code ) < 3 .
      RETURN.
    ENDIF.

    "// Only one separator
    IF count( val = code
              sub =  separator ) > 1.
      RETURN.
    ENDIF.

    "// Position of separator
    DATA(position) = find( val = code
                           sub =  separator ) .

    IF ( position MOD 2 = 1 ) OR ( position >  separator_position ).
      RETURN.
    ENDIF.

    "// There must be > 1 character after the separator
    IF ( numofchar( code ) - position - 1 ) = 1 .
      RETURN.
    ENDIF.

*    // Validate padding
    DATA(padposition) = find( val = code
                              sub =  padding_char ) .


    IF padposition > -1 .

      IF position <  separator_position.
        " Short codes cannot have padding
        RETURN.
      ENDIF.

      IF ( padposition = 0 )  .
        RETURN.
      ENDIF.

      IF ( padposition MOD 2 = 1 ).
        RETURN.
      ENDIF.

      IF ( numofchar( code ) > position + 1 ) .
        RETURN.
      ENDIF.


      DATA(paddingchars) = count( val = code
                                  sub =  padding_char ) .

      IF ( paddingchars MOD 2 = 1 ) .
        RETURN.
      ENDIF.

      DATA(segment) = substring( val = code
                                 off = padposition
                                 len = paddingchars ).
      IF segment CO  padding_char .
        " As expected
      ELSE.
        RETURN.
      ENDIF.

    ENDIF.

    IF to_upper( code ) CO  code_with_sep_and_padd .
      result = abap_true.
    ELSE.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD normalize_longitude.

    result = value.
    WHILE result >=  longitude_max.
      result = result -  longitude_max * '2.0'.
    ENDWHILE.
    WHILE result <  longitude_min.
      result = result +  longitude_max * '2.0'.
    ENDWHILE.

  ENDMETHOD.


  METHOD recover_nearest.

    IF is_short( shortcode ) = abap_false.
      IF is_full( shortcode ) = abap_true.
        result = to_upper( shortcode ) .
        RETURN.
      ELSE.
        result = 'Passed short code is not valid'.
        RETURN.
      ENDIF.
    ENDIF.

    DATA(referencelatitude)  = ref_pt-lat.
    DATA(referencelongitude) = ref_pt-lng.
    referencelatitude = clip_latitude( referencelatitude ).
    referencelongitude = normalize_longitude( referencelongitude ) .
    shortcode = to_upper( shortcode ).

    "// Compute the number of digits we need to recover
    DATA(paddinglength) = find( val = shortcode
                                sub =  separator ) .
    paddinglength =  separator_position - paddinglength.

    " // The resolution (height and width) of the padded area in degrees.
    DATA resolution TYPE decfloat34.
    resolution = 20 ** ( 2 - ( paddinglength / 2 ) ) .

    "// Distance from the center to an edge (in degrees).
    DATA(halfresolution) = resolution / '2.0' .
    "// Use the reference location to pad the supplied short code and decode it.
    DATA refpoint TYPE zif_open_location_code_point~ty_point.
    refpoint-lat = referencelatitude.
    refpoint-lng = referencelongitude.

    DATA(encoderef) = encode( refpoint ).
    encoderef  = substring( val = encoderef
                            off = 0
                            len = paddinglength ).
    encoderef = encoderef && shortcode .


    DATA(codearearesult) = decode(  encoderef ) .

    "// How many degrees latitude is the code from the reference? If it is more
    "// than half the resolution, we need to move it north or south but keep it
    "// within -90 to 90 degrees.
    IF ( referencelatitude + halfresolution ) < codearearesult->get_center_lat( ) AND
       ( codearearesult->get_center_lat( ) - resolution  ) >=  latitude_min .
      "// If the proposed code is more than half a cell north of the reference location,
      "// it's too far, and the best match will be one cell south.
      codearearesult->center_lat_minus( resolution ) .
    ELSEIF ( referencelatitude - halfresolution ) > codearearesult->get_center_lat( ) AND
           ( codearearesult->get_center_lat( ) + resolution  ) <=  latitude_max .

      " If the proposed code is more than half a cell south of the reference location,
      " it's too far, and the best match will be one cell north.
      codearearesult->center_lat_add( resolution ).


    ENDIF.

    "// How many degrees longitude is the code from the reference?
    IF ( referencelongitude + halfresolution ) < codearearesult->get_center_lng( ).
      codearearesult->center_lng_minus( precision = resolution ).
    ELSEIF ( referencelongitude - halfresolution ) > codearearesult->get_center_lng( ) .
      codearearesult->center_lng_add( precision = resolution ) .
    ENDIF.

    result = encode( pt = codearearesult->get_center( )
                     code_length = codearearesult->get_code_length( ) ) .


  ENDMETHOD.


  METHOD shorten.

    "// To upper case
    code = to_upper( code ) .

    "// Can't shorten a short code
    IF is_full( code ) = abap_false.

      result = 'Code is not valid and full' .
      RETURN.
    ENDIF.

    "// Can't shorten a padded code.
    IF count( val = code
              sub =  padding_char ) > 0.
      result = 'Cannot shorten padded codes'.
      RETURN.
    ENDIF.

    "// Can't shorten a too small code length
    DATA codearearesult TYPE REF TO zcl_open_location_code_area.

    codearearesult ?= decode( code ) .

    DATA latitude TYPE decfloat34.
    DATA longitude TYPE decfloat34.

    latitude  = clip_latitude( ref_pt-lat ) .
    longitude = normalize_longitude( ref_pt-lng ) .

    "// How close are the latitude and longitude to the code center?
    DATA range TYPE decfloat34.
    range = nmax( val1 = abs( codearearesult->get_center_lat( ) - latitude )
                  val2 = abs( codearearesult->get_center_lng( ) - longitude ) ).




    DATA(length) = numofchar( code ) .

    DATA(i) = lines(  resolution_values ) - 2 .
    WHILE i >= 1.

      DATA(idx) = i + 1 .

      READ TABLE  resolution_values INTO DATA(resolution_value) INDEX idx.
      IF sy-subrc <> 0.
        ASSERT 0 = 1.
      ENDIF.

      IF range < ( resolution_value-resolution * '0.3' ) .
        DATA(offset) = ( idx ) * 2 .
        length = length - offset .
        result = substring( val = code
                            off = offset
                            len = length ) .
        RETURN.
      ENDIF.

      i = i - 1.

    ENDWHILE.

    result = code .

  ENDMETHOD.
ENDCLASS.
