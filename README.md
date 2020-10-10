# open-location-code-abap
An Open Location Code implementation for ABAP

Open Location Code is an open source location encoding system, encoding latitude and longitude into a memorable codes. Also known as Plus Codes, the Open Location Code is useful for locations where no street addresses exist.

For more information, refer to [Plus Codes](http://plus.codes)

## Implementation
Open Location Code for ABAP implements the Open Location Code specification. See [Open Location Code Specification](https://github.com/google/open-location-code/blob/master/docs/specification.md) The implementation has been influenced by the Rust implementation and the JavaScript implementations found at [Open Location Code on GitHub](https://github.com/google/open-location-code)

The following mandatory methods are provided:

- a method to convert a latitude and longitude into a 10 digit Open Location Code
- a method to decode a 10 digit Open Location Code into, at a minimum, the latitude and longitude of the south-west corner and the height and width
- a method to determine if a string is a valid sequence of Open Location Code characters
- a method to determine if a string is a valid full Open Location Code

The following non-mandatory methods are also provided:

- a method to convert a latitude and longitude into any valid length Open Location Code
- a method to decode any valid length Open Location Code, providing additional information such as center coordinates
- a method to to convert a valid Open Location Code into a short code, given a reference location
- a method to recover a full Open Location Code from a short code and a reference location.
- a method to determine if a string is a valid short Open Location Code

The functionality of Open Location Code for ABAP has been verified by using the test data provided at [GitHub Open Location Code](https://github.com/google/open-location-code) All test cases have been implemented as ABAP Unit Tests and pass.

See <https://github.com/google/open-location-code/> for more documentation and sample implementations.


## Installation
The repository can be cloned to an SAP ABAP system using [abapGit](https://github.com/abapGit/abapGit)

If you do not have an SAP ABAP system with abapGit installed, you can install manually by creating the following repository objects in your SAP system and uploading the source files:

- Create global interface ZIF_OPEN_LOCATION_CODE_POINT and upload `zif_open_location_code_point.intf.abap`
- Create global class ZCL_OPEN_LOCATION_CODE_AREA and upload `zcl_open_location_code_area.class.abap`
- Create global class ZCL_OPEN_LOCATION_CODE and upload `zcl_open_location_code.class.abap`

## Contributions
Contributions are warmly welcomed.

## Next steps
- Various refactorings to the implementation details of some of the larger methods
- Refactoring of the test classes, with particular focus on easily consuming test data from external sources

## License
This code is licensed under the MIT License. 

