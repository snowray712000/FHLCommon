# markdown

## 目標

使以下程式碼，按下 alt+d 時可以跑，但內容是對的

```plantuml
@startuml
skinparam handwritten true
start
:Hello world;
end
@enduml
```

### 作法

- extensions
  - markdown preview enhance
  - markdown all in one
  - plantuml (安裝後可用 atl + d，但還沒裝 java 還不會成功) 
    - 安裝完會變成正確， alt + d 會正確，但 md preview 不會，還有再設定 palantul.jar
    - 下載後，放在一處，然後 copy 路徑。
    - 在 vscode 的 Code -> `喜好設定` -> `Settings`
      - plantumlJarPath      
  

