-- SQL DATA CLEANING AND TRANSFORMATION

SELECT * FROM Nashville;
-- TASK 1 Standardize date format
SELECT 
	SaleDate,CONVERT (DATE,SaleDate)
FROM Nashville;

ALTER TABLE Nashville
ADD  ConvertedSaleDate DATE;

UPDATE Nashville
SET ConvertedSaleDate=CONVERT (DATE,SaleDate);

ALTER TABLE Nashville
DROP COLUMN  SaleDate ;

-- TASK 2 Populate Property Address data
SELECT 
	a.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
	Nashville as a
JOIN Nashville as b
	ON a.ParcelID=b.ParcelID   AND
	a.[UniqueID ]<>b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
	Nashville as a
JOIN Nashville as b
	ON a.ParcelID=b.ParcelID   AND
	a.[UniqueID ]<>b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;


-- TASK 3. Breaking out Address into individual Columns (Address, City, State)
----- FOR Property Address
SELECT 
	PropertyAddress,
	SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM Nashville;


ALTER TABLE Nashville
ADD  SplitedPropertyAddress VARCHAR(100) ;
UPDATE Nashville
SET SplitedPropertyAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE Nashville
ADD  PropertyCity VARCHAR(100) ;
UPDATE Nashville
SET PropertyCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

ALTER TABLE Nashville 
DROP COLUMN ProperAddress;

----- FOR Owner Address
SELECT 
	OwnerAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),3) as ownerAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),2) as ownerCity,
	PARSENAME(REPLACE(OwnerAddress,',','.'),1) as ownerState
FROM Nashville;


ALTER TABLE Nashville
ADD  SplitedOwnerAddress VARCHAR(100) ;
UPDATE Nashville
SET SplitedOwnerAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE Nashville
ADD  OwnerCity VARCHAR(100) ;
UPDATE Nashville
SET OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE Nashville
ADD  OwnerState VARCHAR(100) ;
UPDATE Nashville
SET OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1);

ALTER TABLE Nashville
DROP COLUMN OwnerAddress;

-- TASK 4. Change Y and N to Yes and No in "SoldAsVacant" column
SELECT 
	DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Nashville
GROUP BY 
	SoldAsVacant;
	
UPDATE Nashville
SET SoldAsVacant='Yes'
WHERE SoldAsVacant='Y';

	
UPDATE Nashville
SET SoldAsVacant='No'
WHERE SoldAsVacant='N';




