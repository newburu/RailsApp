# *サービス概要*
日々の体重と食事管理をしてくれるアプリです。
自分が筋トレで食事制限やダイエットをしていた事もありそこで毎日食べた量と体重を管理できるアプリがあればいいなと思い開発しました。

# *これまでの健康管理アプリとの違う点*
既存の健康管理アプリは体重と食事管理機能だけのもが多く以下のようなアプリは存在しませんでした

* タンパク質や糖質などが後どのくらい食べていいのかを１目で分かりやすく教えてくれるアプリがない
* 体重管理と食事を一緒にできるアプリが少ない
* 無料でできるものが少ない

# *使い方*
1. 会員登録をする
まず、新規会員登録画面から身長、体重、運動量などの必須項目を入力します。

2. 食事登録をする
食事登録画面から日付を選んでタンパク質、糖質、カロリーを入力して登録ボタンを押します。
登録した内容がメイン画面に反映されます。

3. 体重登録をする
1日１回体重を登録画面から体重を登録します。
登録した内容がメイン画面のグラフに反映されます。

4. 編集、削除
登録した内容の編集や削除をしたいときはリスト画面から日付を選択すると体重と食事が出てくるのでそこからします。

5. アカウントを編集する
プロフィールボタンを押してプロフィール編集画面からパスワードを入力して編集事項を入力して更新ボタンを押します。

# *使用技術*
* Ruby 3.0.2
* Rails 6.1.4
* jquery
* heroku

# *画面遷移図*
https://www.figma.com/file/Q38wXr5raqnNwyYCACWZma/potohorio?node-id=0%3A1

# *拘った点*
* メイン画面に足りない量のタンパク質と糖質を出すことで一眼でわかりやすくした
* 自分の体重の５%が減量の１ヶ月の目安なのでそこを目標体重にした
* タンパク質は１色で３０グラムまでしか吸収されないので３０グラム以上は保存出来ないようにした
* ユーザー登録で普段の運動量と性別を入力してもらい基礎代謝を正確に計算できるようにした
* 会員登録はできるだけページを分けて項目を減らすことでユーザーの離脱を減らした
* 戻るボタンを小さくすることで操作ミスで戻ってしまうことを防いだ
* 入力フォーマットや制限を予め明示することでお客様がエラー文を見る前にあらかじめ登録する内容をわかりやすくした
* オレンジの色は健康を表す色なのでヘッダーにオレンジの色を入れることでユーザビリティを高めました
