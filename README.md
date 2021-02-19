# HWShimmerCollectionView
Let's use shimmering cell to allow users to use other functions while loading!
You can use this library even if you use data binding, such as rxSwift.

## Requirements

- iOS 11.0+
- Xcode 12+
- Swift 5.0+

## Demos
* [Demo](#demo)

### Demo <a id="demo"></a>

| Demo1 |
|---|
|![9](https://user-images.githubusercontent.com/60125719/108461642-6b087080-72be-11eb-9308-438a6354095f.gif) |
## Usage

### HWShimmerCollectionView is a class that inherits UIView. Create HWShimmerCollectionView by code or UIView inherits HWShimmerCollectionView from storyboard. If you add only a few of my delegate functions, you can use the same datasource and delegate as using the UICollectionView.

```
let myCollectionView: HWShimmerCollectionView = HWShimmerCollectionView(...) 
...
self.myCollectionView.delegate = self
self.myCollectionView.datasource = self
let shimmerLayout = UICollectionViewFlowLayout()
self.myCollectionView.shimmerCollectionViewLayout = shimmerLayout
```

### You need to implement some Delegate functions for HWShimmerCollectionView.
```
/*
   Return the number of shimmering cells.
*/
func numberOfShimmerCollectionViewCell(_ hwCollectionView: HWShimmerCollectionView.HWShimmerCollectionView) -> UInt

/*
   Return the re-use identifier of the shimmering cell for reuse.
*/
func shimmerCollectionViewCellIdentifier(_ hwCollectionView: HWShimmerCollectionView.HWShimmerCollectionView) -> String

```

### Please write layout delegate functions for shimmer Collection View. You can make it the same as the layout of the original or different.
```
@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize

@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets

@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat

@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize

@objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView.HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
```




