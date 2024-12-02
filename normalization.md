
# Database Normalization Analysis

## Current Schema Analysis and Normalization Steps

### 1. First Normal Form (1NF)
The current schema already satisfies 1NF because:
- All tables have a primary key
- All attributes contain atomic values
- No repeating groups exist

#### Verification of 1NF:
1. **User Table**
   - Primary Key: user_id (UUID)
   - All attributes are atomic (first_name, last_name, email, etc.)

2. **Property Table**
   - Primary Key: property_id (UUID)
   - All attributes contain single values

3. **Booking Table**
   - Primary Key: booking_id (UUID)
   - All fields contain single values

4. **Payment Table**
   - Primary Key: payment_id (UUID)
   - All attributes are atomic

5. **Review Table**
   - Primary Key: review_id (UUID)
   - All fields contain single values

6. **Message Table**
   - Primary Key: message_id (UUID)
   - All attributes are atomic

### 2. Second Normal Form (2NF)
The schema is in 2NF because:
- It's already in 1NF
- All non-key attributes are fully functionally dependent on their primary key

#### Verification of 2NF:
1. **User Table**
   - All attributes (first_name, last_name, etc.) depend on the entire primary key (user_id)

2. **Property Table**
   - All attributes depend on property_id
   - No partial dependencies exist

3. **Booking Table**
   - All attributes fully depend on booking_id
   - No partial dependencies on composite keys

4. **Payment Table**
   - All attributes depend on payment_id
   - No partial dependencies exist

5. **Review Table**
   - All attributes depend on review_id
   - No partial dependencies exist

6. **Message Table**
   - All attributes depend on message_id
   - No partial dependencies exist

### 3. Third Normal Form (3NF)
The schema is mostly in 3NF, but some potential improvements can be made:

#### Current Transitive Dependencies:

1. **Property Table**
   - Location information could be normalized
   - Recommendation: Create separate Location table

2. **Payment Table**
   - Payment method details could be normalized
   - Recommendation: Create separate PaymentMethod table

#### Proposed Improvements:

1. **New Location Table**
```sql
CREATE TABLE Location (
    location_id UUID PRIMARY KEY,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL,
    country VARCHAR NOT NULL,
    postal_code VARCHAR NOT NULL,
    address VARCHAR NOT NULL
);

-- Modify Property table
ALTER TABLE Property ADD COLUMN location_id UUID REFERENCES Location(location_id);
```

2.  **New PaymentMethod Table**
```
`CREATE  TABLE PaymentMethod (   
		method_id UUID PRIMARY  KEY, 
		method_name VARCHAR  NOT  NULL, 
		method_type ENUM('credit_card',  'paypal',  'stripe')  NOT  NULL, 
		description VARCHAR 
		);   

-- Modify Payment table 
ALTER  TABLE Payment ADD  COLUMN method_id UUID REFERENCES PaymentMethod(method_id);`
```
### Final 3NF Schema

After implementing these changes, the schema will be fully in 3NF with:

1.  **User Table** (Unchanged)
    -   user_id (PK)
    -   first_name
    -   last_name
    -   email
    -   password_hash
    -   phone_number
    -   role
    -   created_at
2.  **Location Table** (New)
    -   location_id (PK)
    -   city
    -   state
    -   country
    -   postal_code
    -   address
3.  **Property Table** (Modified)
    -   property_id (PK)
    -   host_id (FK)
    -   location_id (FK)
    -   name
    -   description
    -   pricepernight
    -   created_at
    -   updated_at
4.  **Booking Table** (Unchanged)
    -   booking_id (PK)
    -   property_id (FK)
    -   user_id (FK)
    -   start_date
    -   end_date
    -   total_price
    -   status
    -   created_at
5.  **PaymentMethod Table** (New)
    -   method_id (PK)
    -   method_name
    -   method_type
    -   description
6.  **Payment Table** (Modified)
    -   payment_id (PK)
    -   booking_id (FK)
    -   method_id (FK)
    -   amount
    -   payment_date
7.  **Review Table** (Unchanged)
    -   review_id (PK)
    -   property_id (FK)
    -   user_id (FK)
    -   rating
    -   comment
    -   created_at
8.  **Message Table** (Unchanged)
    -   message_id (PK)
    -   sender_id (FK)
    -   recipient_id (FK)
    -   message_body
    -   sent_at

### Benefits of This Normalization

1.  **Reduced Data Redundancy**
    -   Location information is stored once and referenced
    -   Payment methods are standardized
2.  **Better Data Integrity**
    -   Consistent location data across properties
    -   Standardized payment methods
3.  **Easier Maintenance**
    -   Location updates affect all properties automatically
    -   Payment method changes are centralized
4.  **Improved Query Flexibility**
    -   Can easily query properties by location
    -   Better payment method analytics


 This normalization analysis ensures that the database design: 
 - Eliminates redundancy 
 - Maintains data integrity 
 - Provides flexibility for future modifications 
 - Follows database best practices`