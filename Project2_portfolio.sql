
/* 
	Cleaning data using SQL queries 
*/

select * from Project2_portfolio.dbo.NashvilleHousing;


------------------------------------------------------------------------------------------------------------------------
-- Standardize Date format
------------------------------------------------------------------------------------------------------------------------
select SaleDate from Project2_portfolio.dbo.NashvilleHousing;

select SaleDate, convert(date,SaleDate)
from Project2_portfolio.dbo.NashvilleHousing;

Update NashvilleHousing 
set SaleDate = convert(date,SaleDate);

Alter Table NashvilleHousing 
add SaleDateConverted  Date;

Update NashvilleHousing 
set SaleDateConverted = convert(date,SaleDate);

Select SaleDateConverted from NashvilleHousing;

-------------------------------------------------------------------------------------------

-- Populate Property address Data

Select *  from NashvilleHousing
where PropertyAddress is Null;


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;



-------------------------------------------------------------------------------

-- Breaking out Address to individual coloumns(Address,City,State)

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address1,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress))as City
from NashvilleHousing

Alter Table NashvilleHousing 
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) ;

Select PropertySplitAddress , PropertyAddress from NashvilleHousing;

Alter Table NashvilleHousing 
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress)) ;

Select PropertySplitCity , PropertyAddress from NashvilleHousing;


Select Owneraddress,
Parsename(Replace(Owneraddress,',','.'),3)
from NashvilleHousing;

Alter Table NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
set OwnerSplitAddress = Parsename(Replace(Owneraddress,',','.'),3);

Alter Table NashvilleHousing 
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
set OwnerSplitCity = Parsename(Replace(Owneraddress,',','.'),2);

Alter Table NashvilleHousing 
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
set OwnerSplitState = Parsename(Replace(Owneraddress,',','.'),1);

Select * from NashvilleHousing;

------------------------------------------------------------------------------------

-- Change Y and N to Yes and No
------------------------------------------------------------------------------------
Select distinct Soldasvacant from NashvilleHousing

Select Soldasvacant , COUNT(Soldasvacant) as Counts
from NashvilleHousing
group by SoldAsVacant
order by Counts
;


Select Soldasvacant,
CASE 
 When Soldasvacant ='Y' then 'Yes'
 When Soldasvacant = 'N' then 'No'
 else SoldAsVacant
 End
 from NashvilleHousing
 ;

 Update NashvilleHousing 
 set SoldAsVacant = CASE 
 When Soldasvacant ='Y' then 'Yes'
 When Soldasvacant = 'N' then 'No'
 else SoldAsVacant
 End;

 Select Soldasvacant ,COUNT(Soldasvacant)
 from NashvilleHousing
 group by Soldasvacant ;
 
 -------------------------------------------------------------------------------------

 -- Remove Duplicates
 -------------------------------------------------------------------------------------

 Select *, 
 Row_number () Over(
 Partition by ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by 
			  UniqueID
              ) row_num
from NashvilleHousing
order by ParcelID


With RownumCTE AS (
 Select *, 
 Row_number () Over(
 Partition by ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by 
			  UniqueID
              ) row_num
from NashvilleHousing
)
Select * from RownumCTE 
where row_num >1


With RownumCTE AS (
 Select *, 
 Row_number () Over(
 Partition by ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by 
			  UniqueID
              ) row_num
from NashvilleHousing
)
Delete from RownumCTE 
where row_num >1

-------------------------------------------------------------------------------------

-- Delete Unused Coloumns
-------------------------------------------------------------------------------------
Select * from NashvilleHousing

Alter Table NashvilleHousing 
DROP Column OwnerAddress, TaxDistrict, PropertyAddress