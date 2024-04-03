# UICollectionView

## 前言

在選擇經文章節時，對話方塊裡面的按鈕，就是用這個Class來完成的。

相關 class

- VCBookChapPicker

## 使用方式

### 像 tableview

```swift
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _datas.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
    // 設定 cell 的內容 ... 略
    return cell
}

// 初始化 .register .dataSource 設定
override func initedFromXib() {   
    viewCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    viewCollection.dataSource = self
}

// 當資料更新時 .reloadData
private var _datas: [(String,Int?)] = [] {
    didSet {
        self.calcMaxButtonSize()
        self.updateConstraintsForPrettryLayout()
        viewCollection.reloadData()
    }
}

```

