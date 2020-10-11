*"* use this source file for your ABAP unit test classes
INTERFACE if_test_cases.

  TYPES:
    BEGIN OF shortcode_record_type,
      code      TYPE string,
      lat       TYPE decfloat34,
      lng       TYPE decfloat34,
      shortcode TYPE string,
      test_type TYPE c LENGTH 1.
  TYPES: END OF shortcode_record_type .
  TYPES:
    shortcode_records_type TYPE STANDARD TABLE OF shortcode_record_type WITH EMPTY KEY .

  TYPES:
    BEGIN OF validity_record_type,
      code    TYPE string,
      isvalid TYPE abap_bool,
      isshort TYPE abap_bool,
      isfull  TYPE abap_bool.
  TYPES: END OF validity_record_type .
  TYPES:
    validity_records_type TYPE STANDARD TABLE OF validity_record_type WITH EMPTY KEY .

  TYPES:
    BEGIN OF encoding_record_type,
      latitude  TYPE string,
      longitude TYPE string,
      length    TYPE i,
      expected  TYPE string.
  TYPES: END OF encoding_record_type .

  TYPES:
    encoding_records_type TYPE STANDARD TABLE OF encoding_record_type WITH EMPTY KEY .

  TYPES:
    BEGIN OF decoding_record_type,
      code   TYPE string,
      length TYPE i,
      latlo  TYPE decfloat34,
      lnglo  TYPE decfloat34,
      lathi  TYPE decfloat34,
      lnghi  TYPE decfloat34.
  TYPES: END OF decoding_record_type .

  TYPES:
    decoding_records_type TYPE STANDARD TABLE OF decoding_record_type WITH EMPTY KEY .

ENDINTERFACE.

CLASS test_cases_decoding DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.

    METHODS get_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>decoding_records_type.

  PRIVATE SECTION.
    DATA test_records TYPE if_test_cases=>decoding_records_type.
    METHODS load
      IMPORTING
        code   TYPE string
        length TYPE i
        latlo  TYPE decfloat34
        lnglo  TYPE decfloat34
        lathi  TYPE decfloat34
        lnghi  TYPE decfloat34 .
ENDCLASS.

CLASS test_cases_encoding DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.

    METHODS get_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>encoding_records_type.

  PRIVATE SECTION.
    DATA test_records TYPE if_test_cases=>encoding_records_type.
    METHODS load IMPORTING latitude TYPE string longitude TYPE string length TYPE i expected TYPE string.
    METHODS load_long_codes.
    METHODS load_extreme_latlongs.
    METHODS load_rounding_codes.
ENDCLASS.

CLASS test_cases_shortcodes DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.

    METHODS get_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>shortcode_records_type.

    METHODS get_recovery_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>shortcode_records_type.

    METHODS get_shorten_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>shortcode_records_type.

  PRIVATE SECTION.
    DATA test_records TYPE if_test_cases=>shortcode_records_type.
    METHODS load
      IMPORTING code      TYPE string
                lat       TYPE decfloat34
                lng       TYPE decfloat34
                shortcode TYPE string
                test_type TYPE c.

ENDCLASS.
CLASS test_cases_validity DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.

    METHODS get_testdata
      RETURNING VALUE(result) TYPE if_test_cases=>validity_records_type.

  PRIVATE SECTION.
    DATA test_records TYPE if_test_cases=>validity_records_type.
    METHODS load IMPORTING code TYPE string is_valid TYPE abap_bool is_short TYPE abap_bool is_full TYPE abap_bool.
ENDCLASS.

CLASS test_cases_validity IMPLEMENTATION.

  METHOD constructor.


    load( code = '8FWC2345+G6'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '8FWC2345+G6G'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '8fwc2345+'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '8FWCX400+'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = 'WC2345+G6g'
              is_valid = abap_true
              is_short = abap_true
              is_full = abap_false ) .
    load( code = '2345+G6'
              is_valid = abap_true
              is_short = abap_true
              is_full = abap_false ) .
    load( code = '45+G6'
              is_valid = abap_true
              is_short = abap_true
              is_full = abap_false ) .
    load( code = '+G6'
              is_valid = abap_true
              is_short = abap_true
              is_full = abap_false ) .
    load( code = 'G+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = 'G'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '0FWC2345+VX'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = 'F0WC2345+VX'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8F000345+VX'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2345+V'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2345+G'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2345+G6'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '8FWC2_45+G6'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2ÃƒÅ½Ã‚Â·45+G6'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2345+G6+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2345G6+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC2300+G6'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = 'WC2300+G6g'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = 'WC2345+G'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = 'WC2300+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWCX000+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8FWC0000+'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '8FWC00V0+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '8F0C00V0+'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '849VGJQF+VX7QR3J'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '849VGJQF+VX7QR3U'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .
    load( code = '849VGJQF+VX7QR3JW'
              is_valid = abap_true
              is_short = abap_false
              is_full = abap_true ) .
    load( code = '849VGJQF+VX7QR3JU'
              is_valid = abap_false
              is_short = abap_false
              is_full = abap_false ) .

  ENDMETHOD.

  METHOD get_testdata.
    result = test_records.
  ENDMETHOD.

  METHOD load.

    FIELD-SYMBOLS <record> LIKE LINE OF test_records.

    APPEND INITIAL LINE TO test_records ASSIGNING <record>.

    <record>-code = code .
    <record>-isvalid = is_valid.
    <record>-isshort = is_short.
    <record>-isfull = is_full .

  ENDMETHOD.

ENDCLASS.

CLASS test_cases_decoding IMPLEMENTATION.

  METHOD constructor.

    "//  code,length,latLo,lngLo,latHi,lngHi
    load( code = '7FG49Q00+'
              length = '6'
              latlo = '20.35'
              lnglo = '2.75'
              lathi = '20.4'
              lnghi = '2.8' ).
    load( code = '7FG49QCJ+2V'
              length = '10'
              latlo = '20.37'
              lnglo = '2.782125'
              lathi = '20.370125'
              lnghi = '2.78225' ).
    load( code = '7FG49QCJ+2VX'
              length = '11'
              latlo = '20.3701'
              lnglo = '2.78221875'
              lathi = '20.370125'
              lnghi = '2.78225' ).
    load( code = '7FG49QCJ+2VXGJ'
              length = '13'
              latlo = '20.370113'
              lnglo = '2.782234375'
              lathi = '20.370114'
              lnghi = '2.78223632813' ).
    load( code = '8FVC2222+22'
              length = '10'
              latlo = '47.0'
              lnglo = '8.0'
              lathi = '47.000125'
              lnghi = '8.000125' ).
    load( code = '4VCPPQGP+Q9'
              length = '10'
              latlo = '-41.273125'
              lnglo = '174.785875'
              lathi = '-41.273'
              lnghi = '174.786' ).
    load( code = '62G20000+'
              length = '4'
              latlo = '0.0'
              lnglo = '-180.0'
              lathi = '1'
              lnghi = '-179' ).
    load( code = '22220000+'
              length = '4'
              latlo = '-90'
              lnglo = '-180'
              lathi = '-89'
              lnghi = '-179' ).
    load( code = '7FG40000+'
              length = '4'
              latlo = '20.0'
              lnglo = '2.0'
              lathi = '21.0'
              lnghi = '3.0' ).
    load( code = '22222222+22'
              length = '10'
              latlo = '-90.0'
              lnglo = '-180.0'
              lathi = '-89.999875'
              lnghi = '-179.999875' ).
    load( code = '6VGX0000+'
              length = '4'
              latlo = '0'
              lnglo = '179'
              lathi = '1'
              lnghi = '180' ).
    load( code = '6FH32222+222'
              length = '11'
              latlo = '1'
              lnglo = '1'
              lathi = '1.000025'
              lnghi = '1.00003125' ).
    "// Special cases over 90 latitude and 180 longitude
    load( code = 'CFX30000+'
              length = '4'
              latlo = '89'
              lnglo = '1'
              lathi = '90'
              lnghi = '2' ).
    load( code = 'CFX30000+'
              length = '4'
              latlo = '89'
              lnglo = '1'
              lathi = '90'
              lnghi = '2' ).
    load( code = '62H20000+'
              length = '4'
              latlo = '1'
              lnglo = '-180'
              lathi = '2'
              lnghi = '-179' ).
    load( code = '62H30000+'
              length = '4'
              latlo = '1'
              lnglo = '-179'
              lathi = '2'
              lnghi = '-178' ).
    load( code = 'CFX3X2X2+X2'
              length = '10'
              latlo = '89.9998750'
              lnglo = '1'
              lathi = '90'
              lnghi = '1.0001250' ).
    "// Test non-precise latitude/longitude value
    load( code = '6FH56C22+22'
              length = '10'
              latlo = '1.2000000000000028'
              lnglo = '3.4000000000000057'
              lathi = '1.2001249999999999'
              lnghi = '3.4001250000000027' ).
    "// Validate that digits after the first 15 are ignored when decoding
    load( code = '849VGJQF+VX7QR3J'
              length = '15'
              latlo = '37.5396691200'
              lnglo = '-122.3750698242'
              lathi = '37.5396691600'
              lnghi = '-122.3750697021' ).
    load( code = '849VGJQF+VX7QR3J7QR3J'
              length = '15'
              latlo = '37.5396691200'
              lnglo = '-122.3750698242'
              lathi = '37.5396691600'
              lnghi = '-122.3750697021' ).

    "// Attempt to decode a short which shouldn't be possible).
    "// The decoding will provide an exception response. If the exception is expected, then
    "// the test will pass. To indicate an exception response is expected, set latLo = latHi).
    load( code = '2GGG+GG'
              length = '6'
              latlo = '46.976'
              lnglo = '8.526'
              lathi = '46.976'
              lnghi = '8.526' ).


  ENDMETHOD.

  METHOD get_testdata.
    result = test_records.
  ENDMETHOD.

  METHOD load.

    FIELD-SYMBOLS <record> LIKE LINE OF test_records.

    APPEND INITIAL LINE TO test_records ASSIGNING <record>.

    <record>-code = code .
    <record>-length = length.
    <record>-latlo = latlo.
    <record>-lnglo = lnglo .
    <record>-lathi = lathi .
    <record>-lnghi = lnghi .

  ENDMETHOD.

ENDCLASS.

CLASS test_cases_encoding IMPLEMENTATION.

  METHOD constructor.

    load( latitude = '20.375'
              longitude = '2.775'
              length = '6'
              expected = '7FG49Q00+' ).
    load( latitude = '20.3700625'
              longitude = '2.7821875'
              length = '10'
              expected = '7FG49QCJ+2V' ).
    load( latitude = '20.3701125'
              longitude = '2.782234375'
              length = '11'
              expected = '7FG49QCJ+2VX' ).
    load( latitude = '20.3701135'
              longitude = '2.78223535156'
              length = '13'
              expected = '7FG49QCJ+2VXGJ' ).
    load( latitude = '47.0000625'
              longitude = '8.0000625'
              length = '10'
              expected = '8FVC2222+22' ).
    load( latitude = '-41.2730625'
              longitude = '174.7859375'
              length = '10'
              expected = '4VCPPQGP+Q9' ).
    load( latitude = '0.5'
              longitude = '-179.5'
              length = '4'
              expected = '62G20000+' ).
    load( latitude = '-89.5'
              longitude = '-179.5'
              length = '4'
              expected = '22220000+' ).
    load( latitude = '20.5'
              longitude = '2.5'
              length = '4'
              expected = '7FG40000+' ).
    load( latitude = '-89.9999375'
              longitude = '-179.9999375'
              length = '10'
              expected = '22222222+22' ).
    load( latitude = '0.5'
              longitude = '179.5'
              length = '4'
              expected = '6VGX0000+' ).
    load( latitude = '1'
              longitude = '1'
              length = '11'
              expected = '6FH32222+222' ).

    load_extreme_latlongs( ).

    load_long_codes( ).

    load_rounding_codes( ).


*  There is no exact IEEE754 representation of 80.01 (or the negative longitude so test
*  on either side.

    load( latitude = '80.0100000001'
              longitude = '58.57'
              length = '15'
              expected = 'CHGW2H6C+2222222' ).
    load( latitude = '80.0099999999'
              longitude = '58.57'
              length = '15'
              expected = 'CHGW2H5C+X2RRRRR' ).
    load( latitude = '-80.0099999999'
              longitude = '58.57'
              length = '15'
              expected = '2HFWXHRC+2222222' ).
    load( latitude = '-80.0100000001'
              longitude = '58.57'
              length = '15'
              expected = '2HFWXHQC+X2RRRRR' ).

**  Add a few other examples.'
*
    load( latitude = '47.000000080000000'
              longitude = '8.00022229'
              length = '15'
              expected = '8FVC2222+235235C' ).
    load( latitude = '68.3500147997595'
              longitude = '113.625636875353'
              length = '15'
              expected = '9PWM9J2G+272FWJV' ).
    load( latitude = '38.1176000887231'
              longitude = '165.441989844555'
              length = '15'
              expected = '8VC74C9R+2QX445C' ).
    load( latitude = '-28.1217794010122'
              longitude = '-154.066811473758'
              length = '15'
              expected = '5337VWHM+77PR2GR' ).


  ENDMETHOD.

  METHOD get_testdata.
    result = test_records.
  ENDMETHOD.

  METHOD load_rounding_codes.
    "  TEST floating point representation/rounding errors.'
    load( latitude = '35.6'
        longitude = '3.033'
        length = '10'
        expected = '8F75J22M+26' ).
    load( latitude = '-48.71'
        longitude = '142.78'
        length = '8'
        expected = '4R347QRJ+' ).
    load( latitude = '-70'
        longitude = '163.7'
        length = '8'
        expected = '3V252P22+' ).
    load( latitude = '-2.804'
              longitude = '7.003'
    length = '13'
    expected = '6F9952W3+C6222' ).
    load( latitude = '13.9'
              longitude = '164.88'
    length = '12'
    expected = '7V56WV2J+2222' ).
    load( latitude = '-13.23'
              longitude = '172.77'
    length = '8'
    expected = '5VRJQQCC+' ).
    load( latitude = '40.6'
              longitude = '129.7'
    length = '8'
    expected = '8QGFJP22+' ).
    load( latitude = '-52.166'
              longitude = '13.694'
    length = '14'
    expected = '3FVMRMMV+JJ2222' ).
    load( latitude = '-14'
    longitude = '106.9'
    length = '6'
    expected = '5PR82W00+' ).
    load( latitude = '70.3'
        longitude = '-87.64'
        length = '13'
        expected = 'C62J8926+22222' ).
    load( latitude = '66.89'
        longitude = '-106'
        length = '10'
        expected = '95RPV2R2+22' ).
    load( latitude = '2.5'
              longitude = '-64.23'
    length = '11'
    expected = '67JQGQ2C+222' ).
    load( latitude = '-56.7'
              longitude = '-47.2'
    length = '14'
    expected = '38MJ8R22+222222' ).
    load( latitude = '-34.45'
              longitude = '-93.719'
    length = '6'
    expected = '46Q8H700+' ).
    load( latitude = '-35.849'
              longitude = '-93.75'
    length = '12'
    expected = '46P85722+C222' ).
    load( latitude = '65.748'
              longitude = '24.316'
    length = '12'
    expected = '9GQ6P8X8+6C22' ).
    load( latitude = '-57.32'
              longitude = '130.43'
    length = '12'
    expected = '3QJGMCJJ+2222' ).
    load( latitude = '17.6'
              longitude = '-44.4'
    length = '6'
    expected = '789QJJ00+' ).
    load( latitude = '-27.6'
              longitude = '-104.8'
    length = '6'
    expected = '554QC600+' ).
    load( latitude = '41.87'
              longitude = '-145.59'
    length = '13'
    expected = '83HPVCC6+22222' ).
    load( latitude = '-4.542'
              longitude = '148.638'
    length = '13'
    expected = '6R7CFJ5Q+66222' ).
    load( latitude = '-37.014'
              longitude = '-159.936'
    length = '10'
    expected = '43J2X3P7+CJ' ).
    load( latitude = '-57.25'
              longitude = '125.49'
    length = '15'
    expected = '3QJ7QF2R+2222222' ).
    load( latitude = '48.89'
              longitude = '-80.52'
    length = '13'
    expected = '86WXVFRJ+22222' ).
    load( latitude = '53.66'
              longitude = '170.97'
    length = '14'
    expected = '9V5GMX6C+222222' ).
    load( latitude = '0.49'
              longitude = '-76.97'
    length = '15'
    expected = '67G5F2RJ+2222222' ).
    load( latitude = '40.44'
              longitude = '-36.7'
    length = '12'
    expected = '89G5C8R2+2222' ).
    load( latitude = '58.73'
              longitude = '69.95'
    length = '8'
    expected = '9JCFPXJ2+' ).
    load( latitude = '16.179'
              longitude = '150.075'
    length = '12'
    expected = '7R8G53HG+J222' ).
    load( latitude = '-55.574'
              longitude = '-70.061'
    length = '12'
    expected = '37PFCWGQ+CJ22' ).
    load( latitude = '76.1'
              longitude = '-82.5'
    length = '15'
    expected = 'C68V4G22+2222222' ).
    load( latitude = '58.66'
              longitude = '149.17'
    length = '10'
    expected = '9RCFM56C+22' ).
    load( latitude = '-67.2'
              longitude = '48.6'
    length = '6'
    expected = '3H4CRJ00+' ).
    load( latitude = '-5.6'
              longitude = '-54.5'
    length = '14'
    expected = '6867CG22+222222' ).
    load( latitude = '-34'
    longitude = '145.5'
    length = '14'
    expected = '4RR72G22+222222' ).
    load( latitude = '-34.2'
        longitude = '66.4'
        length = '12'
        expected = '4JQ8RC22+2222' ).
    load( latitude = '17.8'
        longitude = '-108.5'
        length = '6'
        expected = '759HRG00+' ).
    load( latitude = '10.734'
        longitude = '-168.294'
        length = '10'
        expected = '722HPPM4+JC' ).
    load( latitude = '-28.732'
        longitude = '54.32'
        length = '8'
        expected = '5H3P789C+' ).
    load( latitude = '64.1'
        longitude = '107.9'
        length = '12'
        expected = '9PP94W22+2222' ).
    load( latitude = '79.7525'
        longitude = '6.9623'
        length = '8'
        expected = 'CFF8QX36+' ).
    load( latitude = '-63.6449'
        longitude = '-25.1475'
        length = '8'
        expected = '398P9V43+' ).
    load( latitude = '35.019'
        longitude = '148.827'
        length = '11'
        expected = '8R7C2R9G+JR2' ).
    load( latitude = '71.132'
        longitude = '-98.584'
        length = '15'
        expected = 'C6334CJ8+RC22222' ).
    load( latitude = '53.38'
        longitude = '-51.34'
        length = '12'
        expected = '985C9MJ6+2222' ).
    load( latitude = '-1.2'
        longitude = '170.2'
        length = '12'
        expected = '6VCGR622+2222' ).
    load( latitude = '50.2'
        longitude = '-162.8'
        length = '11'
        expected = '922V6622+222' ).
    load( latitude = '-25.798'
        longitude = '-59.812'
        length = '10'
        expected = '5862652Q+R6' ).
    load( latitude = '81.654'
        longitude = '-162.422'
        length = '14'
        expected = 'C2HVMH3H+J62222' ).
    load( latitude = '-75.7'
        longitude = '-35.4'
        length = '8'
        expected = '29P68J22+' ).
    load( latitude = '67.2'
        longitude = '115.1'
        length = '11'
        expected = '9PVQ6422+222' ).
    load( latitude = '-78.137'
        longitude = '-42.995'
        length = '12'
        expected = '28HVV274+6222' ).
    load( latitude = '-56.3'
        longitude = '114.5'
        length = '11'
        expected = '3PMPPG22+222' ).
    load( latitude = '10.767'
        longitude = '-62.787'
        length = '13'
        expected = '772VQ687+R6222' ).
    load( latitude = '-19.212'
        longitude = '107.423'
        length = '10'
        expected = '5PG9QCQF+66' ).
    load( latitude = '21.192'
        longitude = '-45.145'
        length = '15'
        expected = '78HP5VR4+R222222' ).
    load( latitude = '16.701'
        longitude = '148.648'
        length = '14'
        expected = '7R8CPJ2X+C62222' ).
    load( latitude = '52.25'
        longitude = '-77.45'
        length = '15'
        expected = '97447H22+2222222' ).
    load( latitude = '-68.54504'
        longitude = '-62.81725'
        length = '11'
        expected = '373VF53M+X4J' ).
    load( latitude = '76.7'
        longitude = '-86.172'
        length = '12'
        expected = 'C68MPR2H+2622' ).
    load( latitude = '-6.2'
        longitude = '96.6'
        length = '13'
        expected = '6M5RRJ22+22222' ).
    load( latitude = '59.32'
        longitude = '-157.21'
        length = '12'
        expected = '93F48QCR+2222' ).
    load( latitude = '29.7'
        longitude = '39.6'
        length = '12'
        expected = '7GXXPJ22+2222' ).
    load( latitude = '-18.32'
        longitude = '96.397'
        length = '10'
        expected = '5MHRM9JW+2R' ).
    load( latitude = '-30.3'
        longitude = '76.5'
        length = '11'
        expected = '4JXRPG22+222' ).
    load( latitude = '50.342'
        longitude = '-112.534'
        length = '15'
        expected = '95298FR8+RC22222' ).
  ENDMETHOD.

  METHOD load_extreme_latlongs.

    "  Special cases over 90 latitude and 180 longitude'
    load( latitude = '90'
              longitude = '1'
              length = '4'
              expected = 'CFX30000+' ).
    load( latitude = '92'
              longitude = '1'
              length = '4'
              expected = 'CFX30000+' ).
    load( latitude = '1'
              longitude = '180'
              length = '4'
              expected = '62H20000+' ).
    load( latitude = '1'
              longitude = '181'
              length = '4'
              expected = '62H30000+' ).
    load( latitude = '90'
              longitude = '1'
              length = '10'
              expected = 'CFX3X2X2+X2' ).


**  Test non-precise latitude/longitude value'
    load( latitude = '1.2'
              longitude = '3.4'
              length = '10'
              expected = '6FH56C22+22' ).

  ENDMETHOD.

  METHOD load_long_codes.
    "  Validate that codes generated with a length exceeding 15 significant digits'
    "  return a 15-digit code'
    load( latitude = '37.539669125'
        longitude = '-122.375069724'
        length = '15'
        expected = '849VGJQF+VX7QR3J' ).
    load( latitude = '37.539669125'
              longitude = '-122.375069724'
              length = '16'
              expected = '849VGJQF+VX7QR3J' ).
    load( latitude = '37.539669125'
              longitude = '-122.375069724'
              length = '100'
              expected = '849VGJQF+VX7QR3J' ).
  ENDMETHOD.

  METHOD load.

    FIELD-SYMBOLS <record> LIKE LINE OF test_records.

    APPEND INITIAL LINE TO test_records ASSIGNING <record>.

    <record>-latitude = latitude .
    <record>-longitude = longitude.
    <record>-length = length.
    <record>-expected = expected .

  ENDMETHOD.

ENDCLASS.

CLASS test_cases_shortcodes IMPLEMENTATION.

  METHOD constructor.

    "  Test shortening , recovery and extending codes
    "  full code lat lng shortcode test_type
    "  test_type is R for recovery only S for shorten only or B for both
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3701125'
              lng = '-1.217765625'
              shortcode = '+2VX'
              test_type = 'B' ).
    "  Adjust so we can't trim by 8 (+/- .000755)
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3708675'
              lng = '-1.217765625'
              shortcode = 'CJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3693575'
              lng = '-1.217765625'
              shortcode = 'CJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3701125'
              lng = '-1.218520625'
              shortcode = 'CJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3701125'
              lng = '-1.217010625'
              shortcode = 'CJ+2VX'
              test_type = 'B' ).
    "  Adjust so we can't trim by 6 (+/- .0151)
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3852125'
              lng = '-1.217765625'
              shortcode = '9QCJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3550125'
              lng = '-1.217765625'
              shortcode = '9QCJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3701125'
              lng = '-1.232865625'
              shortcode = '9QCJ+2VX'
              test_type = 'B' ).
    load( code = '9C3W9QCJ+2VX'
              lat = '51.3701125'
              lng = '-1.202665625'
              shortcode = '9QCJ+2VX'
              test_type = 'B' ).
    "  Added to detect error in recoverNearest functionality
    load( code = '8FJFW222+'
              lat = '42.899'
              lng = '9.012'
              shortcode = '22+'
              test_type = 'B' ).
    load( code = '796RXG22+'
              lat = '14.95125'
              lng = '-23.5001'
              shortcode = '22+'
              test_type = 'B' ).
    "  Reference location is in the 4 digit cell to the south.
    load( code = '8FVC2GGG+GG'
              lat = '46.976'
              lng = '8.526'
              shortcode = '2GGG+GG'
              test_type = 'B' ).
    "  Reference location is in the 4 digit cell to the north.
    load( code = '8FRCXGGG+GG'
              lat = '47.026'
              lng = '8.526'
              shortcode = 'XGGG+GG'
              test_type = 'B' ).
    "  Reference location is in the 4 digit cell to the east.
    load( code = '8FR9GXGG+GG'
              lat = '46.526'
              lng = '8.026'
              shortcode = 'GXGG+GG'
              test_type = 'B' ).
    "  Reference location is in the 4 digit cell to the west.
    load( code = '8FRCG2GG+GG'
              lat = '46.526'
              lng = '7.976'
              shortcode = 'G2GG+GG'
              test_type = 'B' ).
    "  Added to detect errors recovering codes near the poles.'
    "  This tests recovery function but these codes won't shorten.'
    load( code = 'CFX22222+22'
              lat = '89.6'
              lng = '0.0'
              shortcode = '2222+22'
              test_type = 'R' ).
    load( code = '2CXXXXXX+XX'
              lat = '-81.0'
              lng = '0.0'
              shortcode = 'XXXXXX+XX'
              test_type = 'R' ).
    "  Recovered full codes should be the full code' ).
    load( code = '8FRCG2GG+GG'
              lat = '46.526'
              lng = '7.976'
              shortcode = '8FRCG2GG+GG'
              test_type = 'R' ).
    "  Recovered full codes should be the uppercased full code' ).
    load( code = '8FRCG2GG+GG'
              lat = '46.526'
              lng = '7.976'
              shortcode = '8frCG2GG+gG'
              test_type = 'R' ).
    " An invalid short code to check code coverage
    load( code = 'Passed short code is not valid'
              lat = '46.976'
              lng = '8.526'
              shortcode = '2G0G+GG'
              test_type = 'R' ).
    " Can't shorten a short code
    load( code = 'G2GG+GG'
              lat = '46.976'
              lng = '8.526'
              shortcode = 'Code is not valid and full'
              test_type = 'S' ).
    " Can't shorten a padded code
    load( code = '62G20000+'
              lat = '46.976'
              lng = '8.526'
              shortcode = 'Cannot shorten padded codes'
              test_type = 'S' ).

  ENDMETHOD.

  METHOD get_testdata.
    result = test_records.
  ENDMETHOD.

  METHOD get_recovery_testdata.

    LOOP AT test_records INTO DATA(test_record)
       WHERE test_type = 'R' OR test_type = 'B'.
      INSERT test_record INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_shorten_testdata.

    LOOP AT test_records INTO DATA(test_record)
       WHERE test_type = 'S' OR test_type = 'B'.
      INSERT test_record INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.


  METHOD load.

    FIELD-SYMBOLS <record> LIKE LINE OF test_records.

    APPEND INITIAL LINE TO test_records ASSIGNING <record>.

    <record>-code = code .
    <record>-lat = lat.
    <record>-lng = lng.
    <record>-shortcode = shortcode.
    <record>-test_type = test_type.

  ENDMETHOD.

ENDCLASS.


CLASS test_open_location_code DEFINITION
  FOR TESTING
  DURATION MEDIUM
  RISK LEVEL HARMLESS .

  PUBLIC SECTION.
    INTERFACES zif_open_location_code_point .

  PROTECTED SECTION.
    ALIASES point
  FOR zif_open_location_code_point~ty_point .


    TYPES:
      BEGIN OF precision_record_type,
        length TYPE i,
        value  TYPE decfloat34.
    TYPES: END OF precision_record_type .
    TYPES:
      precision_records_type TYPE STANDARD TABLE OF precision_record_type WITH EMPTY KEY .

    DATA olc TYPE REF TO zcl_open_location_code .
  PRIVATE SECTION.
    METHODS setup .

    "! Test the encoding alphabet is as expected
    METHODS test_alphabet
        FOR TESTING .
    "! Test encoding
    METHODS test_encode
        FOR TESTING .
    "! Test shortening
    METHODS test_shorten
        FOR TESTING .
    "! Test recovery
    METHODS test_recovery
        FOR TESTING .
    "! Test whether code is valid
    METHODS test_is_valid
        FOR TESTING .
    "! Test whether code is a full Open Location Code
    METHODS test_is_full
        FOR TESTING .
    "! Test whether code is a short Open Location Code
    METHODS test_is_short
        FOR TESTING .
    "! Test where codes can be decoded
    METHODS test_decode
        FOR TESTING .
    "! Test whether Open Location Code can be decoded
    METHODS decode
      IMPORTING
        test_record TYPE if_test_cases=>decoding_record_type .


ENDCLASS.

CLASS test_open_location_code IMPLEMENTATION.


  METHOD setup.
    olc = NEW #( ).
  ENDMETHOD.


  METHOD test_alphabet.

    cl_abap_unit_assert=>assert_equals( act = olc->get_alphabet( )
                                        exp = '23456789CFGHJMPQRVWX' ).

  ENDMETHOD.

  METHOD decode.


    DATA tolerance TYPE f VALUE '1.E-10'.


    TRY.

        DATA(actual) = olc->decode( code = test_record-code ).

        "// Length ?
        cl_abap_unit_assert=>assert_equals( act = actual->get_code_length( )
                                            exp = test_record-length
                                            msg = test_record-code && ' Length'
                                            quit = if_aunit_constants=>no ).

        "// latLo = south
        cl_abap_unit_assert=>assert_equals_float(
                                            act = actual->get_south( )
                                            exp = test_record-latlo
                                            rtol = tolerance
                                            msg = test_record-code && ' latLo'
                                            quit = if_aunit_constants=>no ).

        "// lngLo = west
        cl_abap_unit_assert=>assert_equals_float( act = actual->get_west( )
                                            exp = test_record-lnglo
                                            rtol = tolerance
                                            msg = test_record-code && ' lngLo'
                                            quit = if_aunit_constants=>no ).

        "// latHi = north
        cl_abap_unit_assert=>assert_equals_float( act = actual->get_north( )
                                            exp = test_record-lathi
                                            rtol = tolerance
                                            msg = test_record-code && ' latHi'
                                            quit = if_aunit_constants=>no ).


        "// lngHi = east
        cl_abap_unit_assert=>assert_equals_float( act = actual->get_east( )
                                            exp = test_record-lnghi
                                            rtol = tolerance
                                             msg = test_record-code && ' lngHi'
                                            quit = if_aunit_constants=>no ).


      CATCH zcx_open_location_code.
        cl_abap_unit_assert=>assert_equals( act = test_record-latlo
                                            exp = test_record-lathi
                                            msg = test_record-code
                                            quit = if_aunit_constants=>no ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_decode.


    DATA(test_cases) = NEW test_cases_decoding( ).
    DATA(test_data) = test_cases->get_testdata( ).

    LOOP AT test_data INTO DATA(test_record).

      decode( test_record ) .

    ENDLOOP.

  ENDMETHOD.


  METHOD test_encode.


    DATA(test_cases)  = NEW test_cases_encoding( ).

    DATA pt TYPE point.

    DATA(test_records) = test_cases->get_testdata( ).

    LOOP AT test_records INTO DATA(test_record).

      CLEAR pt.

      pt-lat = test_record-latitude.
      pt-lng = test_record-longitude.

      cl_abap_unit_assert=>assert_equals( act =  olc->encode( pt = pt code_length = test_record-length  )
                                          exp = test_record-expected
                                          msg = test_record-expected
                                          quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD test_is_full.


    DATA(test_cases) = NEW test_cases_validity( ).
    DATA(test_data) = test_cases->get_testdata( ).

    LOOP AT test_data INTO DATA(test_record).

      cl_abap_unit_assert=>assert_equals( act = olc->is_full( test_record-code )
                                          exp = test_record-isfull
                                          msg = test_record-code
                                          quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD test_is_short.

    DATA(test_cases) = NEW test_cases_validity( ).

    DATA(test_data) = test_cases->get_testdata( ).


    LOOP AT test_data INTO DATA(test_record).

      cl_abap_unit_assert=>assert_equals( act = olc->is_short( test_record-code )
                                          exp = test_record-isshort
                                          msg = test_record-code
                                          quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD test_is_valid.

    DATA(test_cases) = NEW test_cases_validity( ).

    DATA(test_data) = test_cases->get_testdata( ).


    LOOP AT test_data INTO DATA(test_record).

      cl_abap_unit_assert=>assert_equals( act = olc->is_valid( test_record-code )
                                          exp = test_record-isvalid
                                          msg = test_record-code
                                          quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD test_recovery.

    DATA(test_cases) = NEW test_cases_shortcodes( ).

    DATA(test_data) = test_cases->get_recovery_testdata( ).


    DATA pt TYPE point.

    LOOP AT test_data INTO DATA(test_record) .

      CLEAR pt.
      pt-lat = test_record-lat .
      pt-lng = test_record-lng .


      cl_abap_unit_assert=>assert_equals( act = olc->recover_nearest( shortcode = test_record-shortcode ref_pt = pt  )
                                           exp = test_record-code
                                           msg = test_record-code
                                           quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD test_shorten.

    DATA(test_cases) = NEW test_cases_shortcodes( ).

    DATA(test_data) = test_cases->get_shorten_testdata( ).

    DATA pt TYPE point.

    DATA(index) = 0.

    LOOP AT test_data INTO DATA(test_record) .


      index = index + 1.
      CLEAR pt.
      pt-lat = test_record-lat.
      pt-lng = test_record-lng .

      cl_abap_unit_assert=>assert_equals( act = olc->shorten( code = test_record-code ref_pt = pt  )
                                          exp = test_record-shortcode
                                          msg = test_record-code && 'Test Index: ' && index
                                          quit = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
