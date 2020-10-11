CLASS zcl_open_location_code_area DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_open_location_code_point .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter i_south | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter i_west | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter i_north | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter i_east | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter i_code_length | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_result | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS create
      IMPORTING
        south         TYPE decfloat34
        west          TYPE decfloat34
        north         TYPE decfloat34
        east          TYPE decfloat34
        code_length   TYPE i
      RETURNING
        VALUE(result) TYPE REF TO zcl_open_location_code_area.

        "! Get south
    METHODS get_south RETURNING VALUE(result) TYPE decfloat34.
      "! Get west
    METHODS get_west RETURNING VALUE(result) TYPE decfloat34.
      "! Get north
    METHODS get_north RETURNING VALUE(result) TYPE decfloat34.
      "! Get east
    METHODS get_east RETURNING VALUE(result) TYPE decfloat34.
      "! Get centre point
    METHODS get_center RETURNING VALUE(result) TYPE zif_open_location_code_point=>ty_point.
      "! Get latitude of center point
    METHODS get_center_lat RETURNING VALUE(result) TYPE decfloat34.
      "! Get longitude of centre point
    METHODS get_center_lng RETURNING VALUE(result) TYPE decfloat34.
      "! Get length of code
    METHODS get_code_length RETURNING VALUE(result) TYPE i.
      "! Add a value to the latitude
    METHODS center_lat_add IMPORTING VALUE(precision) TYPE decfloat34 RETURNING VALUE(result) TYPE decfloat34.
      "! Subtract a value from the latitude
    METHODS center_lat_minus IMPORTING VALUE(precision) TYPE decfloat34 RETURNING VALUE(result) TYPE decfloat34.
      "! Subtract a value from the longitude
    METHODS center_lng_minus IMPORTING VALUE(precision) TYPE decfloat34 RETURNING VALUE(result) TYPE decfloat34.
      "! Add a value to the longitude
    METHODS center_lng_add IMPORTING VALUE(precision) TYPE decfloat34 RETURNING VALUE(result) TYPE decfloat34.

  PROTECTED SECTION.
    " South is also known as latitude low
    DATA south TYPE decfloat34.
    "West is also known as longitude low
    DATA west  TYPE decfloat34.
    " North is also known as latitude high
    DATA north TYPE decfloat34.
    " East is also known as longitude high
    DATA east  TYPE decfloat34.
    " The bounding box - center latitude and center longitude
    DATA center TYPE zif_open_location_code_point=>ty_point.
    DATA code_length TYPE i.


  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OPEN_LOCATION_CODE_AREA IMPLEMENTATION.


  METHOD center_lat_add.
    center-lat = center-lat + precision.
    result = center-lat.
  ENDMETHOD.


  METHOD center_lat_minus.
    center-lat = center-lat - precision .
    result = center-lat.
  ENDMETHOD.


  METHOD center_lng_add.
    center-lng = center-lng + precision .
    result = center-lng.
  ENDMETHOD.


  METHOD center_lng_minus.
    center-lng = center-lng - precision .
    result = center-lng.
  ENDMETHOD.


  METHOD create.

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

    result = NEW #( ).

    result->south = south.
    result->west = west.
    result->north = north.
    result->east = east.
    result->code_length = code_length.
    result->center-lng = ( west  + east  ) / 2 .
    result->center-lat = ( south + north ) / 2 .


  ENDMETHOD.


  METHOD get_center.
    result = me->center.
  ENDMETHOD.


  METHOD get_center_lat.
    result = me->center-lat.
  ENDMETHOD.


  METHOD get_center_lng.
    result = me->center-lng.
  ENDMETHOD.


  METHOD get_code_length.
    result = me->code_length.
  ENDMETHOD.


  METHOD get_east.
    result = me->east.
  ENDMETHOD.


  METHOD get_north.
    result = me->north.
  ENDMETHOD.


  METHOD get_south.
    result = me->south.
  ENDMETHOD.


  METHOD get_west.
    result = me->west.
  ENDMETHOD.
ENDCLASS.
