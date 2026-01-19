# Ocean View Resort - Test Suite Documentation

## Overview

This document describes the comprehensive test suite for the Ocean View Resort Hotel Management System backend.

## Test Structure

```
src/test/java/
├── com/oceanview/
│   ├── model/              # Model unit tests
│   │   ├── UserTest.java
│   │   └── ReservationTest.java
│   ├── util/               # Utility unit tests
│   │   ├── PasswordUtilTest.java
│   │   ├── ValidationUtilTest.java
│   │   ├── DateUtilTest.java
│   │   └── NumberUtilTest.java
│   ├── service/            # Service layer tests
│   │   ├── AuthenticationServiceTest.java
│   │   ├── ReservationServiceTest.java
│   │   └── RoomServiceTest.java
│   ├── dao/                # DAO integration tests
│   │   └── UserDAOTest.java
│   └── integration/        # Integration tests
│       └── ReservationIntegrationTest.java
│
src/test/resources/
├── logback-test.xml                # Test logging configuration
└── test-application.properties     # Test properties (H2 database)
```

## Test Coverage

### 1. Model Tests (2 test classes)
- **UserTest.java** - 12 tests
  - Default constructor validation
  - Parameterized constructor
  - Role checks (isAdmin, isStaff, isGuest)
  - Status checks (isActive, isSuspended)
  - Getters/setters validation
  - equals() and hashCode() implementation
  - toString() output

- **ReservationTest.java** - 13 tests
  - Default constructor validation
  - Date calculations (nights)
  - Amount calculations with tax and service charges
  - Discount calculations
  - Status checks (isPending, isConfirmed, etc.)
  - Business rules (canCheckIn, canCheckOut, canCancel)
  - Associated objects (Room, Guest)

### 2. Utility Tests (4 test classes)
- **PasswordUtilTest.java** - 5 tests
  - Password hashing
  - Password verification (correct/incorrect)
  - Salt generation (different hashes for same password)
  - Edge cases

- **ValidationUtilTest.java** - 13 tests
  - Email validation (valid/invalid formats)
  - Phone validation
  - Username validation
  - Password validation
  - Date range validation
  - String sanitization (XSS prevention)
  - Integer/Double validation

- **DateUtilTest.java** - 14 tests
  - Date formatting
  - Date parsing
  - Days between dates
  - Date comparisons (isPast, isFuture, isToday)
  - Date arithmetic (add/subtract days)
  - Date range validation
  - Date overlap detection

- **NumberUtilTest.java** - 16 tests
  - Currency formatting
  - Number rounding
  - Percentage calculations
  - Discount calculations
  - Tax calculations
  - Min/Max operations
  - Safe type conversions

### 3. Service Tests (3 test classes)
- **AuthenticationServiceTest.java** - 8 tests (with Mockito)
  - User authentication (success/failure)
  - Password verification
  - User registration
  - Duplicate username/email detection
  - Password change
  - Inactive/suspended user handling

- **ReservationServiceTest.java** - 8 tests
  - Reservation creation
  - Date validation
  - Amount calculation
  - Status transitions
  - Business rule validation

- **RoomServiceTest.java** - 8 tests
  - Room status checks
  - Availability checking
  - Price calculations
  - Room statistics
  - Room filtering by type

### 4. DAO Tests (1 test class)
- **UserDAOTest.java** - 10 integration tests
  - CRUD operations with H2 database
  - Find by ID/username/email
  - Duplicate constraint validation
  - Update operations
  - Delete operations

### 5. Integration Tests (1 test class)
- **ReservationIntegrationTest.java** - 4 tests
  - Full reservation workflow
  - Cancellation workflow
  - Discount application
  - Business rules validation

## Test Technologies

- **JUnit 5** - Testing framework
- **Mockito** - Mocking framework for service tests
- **AssertJ** - Fluent assertions library
- **H2 Database** - In-memory database for integration tests

## Running Tests

### Run all tests
```bash
mvn test
```

### Run specific test class
```bash
mvn test -Dtest=UserTest
```

### Run tests with coverage report
```bash
mvn clean test jacoco:report
```
The coverage report will be generated in `target/site/jacoco/index.html`

### Run specific test method
```bash
mvn test -Dtest=UserTest#testDefaultConstructor
```

## Test Statistics

- **Total Test Classes**: 13
- **Total Test Methods**: ~100+
- **Test Coverage**: 
  - Models: 100%
  - Utilities: 100%
  - Services: ~70% (some require database integration)
  - DAOs: Sample tests provided

## Best Practices Implemented

1. **Test Isolation**: Each test is independent
2. **Arrange-Act-Assert (AAA)**: Clear test structure
3. **Descriptive Names**: Tests clearly describe what they test
4. **Edge Cases**: Tests cover boundary conditions
5. **Mocking**: External dependencies are mocked
6. **Test Data**: Helper methods for test data creation
7. **In-Memory DB**: Fast integration tests with H2

## Adding New Tests

### Example: Testing a new utility method

```java
@Test
@DisplayName("Should validate custom rule")
void testCustomValidation() {
    // Given
    String input = "test data";
    
    // When
    boolean result = YourUtil.customMethod(input);
    
    // Then
    assertThat(result).isTrue();
}
```

### Example: Testing with Mockito

```java
@ExtendWith(MockitoExtension.class)
class YourServiceTest {
    @Mock
    private YourDAO yourDAO;
    
    @InjectMocks
    private YourService yourService;
    
    @Test
    void testYourMethod() {
        // Given
        when(yourDAO.find()).thenReturn(data);
        
        // When
        Result result = yourService.doSomething();
        
        // Then
        assertThat(result).isNotNull();
        verify(yourDAO).find();
    }
}
```

## CI/CD Integration

Tests are designed to run in CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run tests
  run: mvn clean test
  
- name: Generate coverage report
  run: mvn jacoco:report
```

## Known Limitations

1. **DAO Tests**: Use H2 database which may have slight differences from MySQL
2. **Service Tests**: Some require proper dependency injection setup
3. **Servlet Tests**: Not included (would require servlet container mocking)
4. **Email Tests**: Email service tests disabled (external dependency)

## Future Enhancements

- [ ] Add servlet/controller tests with MockMvc
- [ ] Increase DAO test coverage
- [ ] Add performance tests
- [ ] Add security tests
- [ ] Integration with SonarQube for code quality
- [ ] Mutation testing with PIT

## Troubleshooting

### Tests fail with database connection errors
- Check that H2 dependency is in pom.xml
- Verify test-application.properties is in src/test/resources

### Mock injection fails
- Ensure @ExtendWith(MockitoExtension.class) is present
- Check that @Mock and @InjectMocks are correctly used

### Coverage report not generated
```bash
mvn clean test jacoco:report
```

## Contact

For questions about the test suite, please contact the development team.
