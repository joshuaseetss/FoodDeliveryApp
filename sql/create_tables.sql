--ENTITIES
CREATE TABLE Users ( -- BCNF 
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    username VARCHAR(100),
    password VARCHAR(100),
    role_type VARCHAR(100),
    date_joined TIMESTAMP,
    UNIQUE(username)
);

CREATE TABLE Riders ( -- BCNF
    rider_id INTEGER REFERENCES Users(uid)
        ON DELETE CASCADE,
    rating DECIMAL,
    working BOOLEAN, --to know if he's working now or not
    is_delivering BOOLEAN,--to know if he's free or not
    rider_type BOOLEAN, --pt f or ft t
    PRIMARY KEY(rider_id),
    UNIQUE(rider_id)
);

CREATE TABLE RidersSalary ( -- BCNF
    rider_type BOOLEAN,
    commission INTEGER,
    base_salary DECIMAL,
    PRIMARY KEY(rider_type)
);

CREATE TABLE Restaurants ( -- BCNF
    rid INTEGER PRIMARY KEY,
    rname VARCHAR(100),
    location VARCHAR(100),
    min_order_price DECIMAL,
    unique(rid)
);

CREATE TABLE RestaurantStaff ( --BCNF
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE,
    rid INTEGER REFERENCES Restaurants(rid)
        ON DELETE CASCADE
);

CREATE TABLE FDSManager ( --BCNF
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE PRIMARY KEY
);

CREATE TABLE Customers ( --BCNF
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE PRIMARY KEY,
    points INTEGER,
    credit_card VARCHAR(100)
);

CREATE TABLE FoodOrder ( --BCNF
    order_id SERIAL PRIMARY KEY NOT NULL,
    uid INTEGER REFERENCES Customers NOT NULL,
    rid INTEGER REFERENCES Restaurants NOT NULL,
    have_credit_card BOOLEAN,
    order_cost DECIMAL NOT NULL,
    date_time TIMESTAMP NOT NULL,
    completion_status BOOLEAN,
    UNIQUE(order_id)
);

CREATE TABLE FoodItem ( --BCNF
    food_id SERIAL NOT NULL, 
    rid INTEGER REFERENCES Restaurants
        ON DELETE CASCADE,
    cuisine_type VARCHAR(100),
    food_name VARCHAR(100),
    restaurant_quantity INTEGER,
    overall_rating DECIMAL,
    ordered_count INTEGER,
    availability_status BOOLEAN,
    is_deleted BOOLEAN,
    PRIMARY KEY(food_id, rid),
    UNIQUE(food_id)
);

CREATE TABLE PromotionalCampaign ( --BCNF
    promo_id SERIAL PRIMARY KEY,
    rid INTEGER REFERENCES Restaurants 
        ON DELETE CASCADE,
    discount INTEGER,
    description VARCHAR(100),
    start_date TIMESTAMP,
    end_date TIMESTAMP
);

CREATE TABLE FDSPromotionalCampaign ( --BCNF
    promo_id SERIAL PRIMARY KEY,
    discount INTEGER,
    description VARCHAR(100),
    start_date TIMESTAMP,
    end_date TIMESTAMP
);

CREATE TABLE WeeklyWorkSchedule ( --BCNF
    wws_id SERIAL PRIMARY KEY NOT NULL,
    rider_id INTEGER references Riders(rider_id),
    start_hour INTEGER,
    end_hour INTEGER,
    day INTEGER,
    week INTEGER,
    month INTEGER,
    year INTEGER
);

CREATE TABLE MonthlyWorkSchedule ( --BCNF
    rider_id INTEGER references Riders(rider_id),
    start_hour INTEGER,
    end_hour INTEGER,
    day INTEGER,
    month INTEGER,
    year INTEGER,
    shift INTEGER,
    PRIMARY KEY(rider_id,start_hour,end_hour,day,month,year)
);
--ENTITIES

--RELATIONSHIPS

CREATE TABLE Sells (
    rid INTEGER REFERENCES Restaurants(rid) NOT NULL,
    food_id INTEGER REFERENCES FoodItem(food_id) ON DELETE CASCADE,
    price DECIMAL NOT NULL check (price > 0),
    PRIMARY KEY(rid, food_id)
);

CREATE TABLE OrdersContain (
    order_id INTEGER REFERENCES FoodOrder(order_id),
    food_id INTEGER REFERENCES FoodItem(food_id),
    item_quantity INTEGER,
    PRIMARY KEY(order_id,food_id)
);

CREATE TABLE Receives (
    order_id INTEGER REFERENCES FoodOrder(order_id),
    promo_id INTEGER REFERENCES PromotionalCampaign(promo_id)
);

CREATE TABLE Delivery (
    delivery_id SERIAL NOT NULL,
    order_id INTEGER REFERENCES FoodOrder(order_id) NOT NULL,
    rider_id INTEGER REFERENCES Riders(rider_id) NOT NULL,
    delivery_cost DECIMAL NOT NULL,
    departure_time TIMESTAMP,
    collected_time TIMESTAMP,
    delivery_start_time TIMESTAMP, --start delivering to customer
    delivery_end_time TIMESTAMP,
    location VARCHAR(100),
    delivery_rating INTEGER, 
    food_review varchar(100),
    ongoing BOOLEAN, --true means delivering, false means done
    PRIMARY KEY(delivery_id),
    UNIQUE(delivery_id)
);

CREATE TABLE DeliveryDuration ( --BCNF
    delivery_id INTEGER REFERENCES Delivery(delivery_id),
    time_for_one_delivery DECIMAL --in minutes
);

--RELATIONSHIPS