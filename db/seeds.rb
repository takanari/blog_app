# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.create(
:title => 'S3へのアップロード速度を上げる方法',
:content => '以前、S3への転送が遅い件について に書いたように、自宅 Mac mini からS3へのバックアップファイル転送ですが、単純に aws-sdk(Ruby版)を使うより2倍程度になったので書いておきます。 



writeメソッドのオプションを指定しよう 

AWS::S3::S3Objectのwriteメソッドのドキュメントを見ると、いくつかオプションがあります。ここで転送速度と関係しそうなものには 
: single_request 転送を一回で行うか、分割して行うか。デフォルトは分割(false) 
:multipart_threshold 小さいファイルの場合は分割しない、しきい値。デフォルト 16Mbye 
: multipart_min_part_size 分割する際の大きさ。デフォルト 5Mbye 
今回はバックアップなので転送するファイルは 数100Mbye～数Gbyte です。 デフォルトだと5Mbyeのファイルに分割して送っています。試しに multipart_min_part_size を大きくしたところ、転送時間が多少改善しました。 
:single_request => true にして試したところ、デフォルトの半分程度の転送時間になりました！ 
single_requestで送るとということは一旦ファイルをメモリーに全部取り込んでからS3へ転送されます、したがってメモリーを大量に消費します。バックアップを行っている時に Mac mini は他には何も行っていないので今回は問題ないですが、使用環境によっては multipart_min_part_size を調整する方が良い場合もあると思います。',
:user_id => 1
)

Post.create(
:title => 'ssh ログインで ~/.ssh/id_ras が優先されるのを防ぐには',
:content => 'GitLab を開発用サーバーに入れて運用し始めたのですが ~/.ssh/config に接続用の秘密キーを指定しても ~/.ssh/id_ras を使って接続しょうとしエラーになり困っていました。 
実用SSH 第2版―セキュアシェル徹底活用ガイド 
GitHub風システム、GitLab は ssh 接続のgitコマンドからのアクセス時には、sshのキーを使いユーザーを管理しています。 
もし1人のUnix(Mac)アカウントがGitLabに複数のユーザーを登録していて、ユーザーAの公開キーが ~/.ssh/id_ras に対応するもので、ユーザーBの 公開キーが ~/.ssh/id_ras_git の場合を考えてみましょう(各ユーザーのリポジトリーはユーザーだけがアクセス出来ます)。ユーザーBに対応するリポジトリーをアクセスする際に ~/.ssh/config に 
... 
なぜか ~/.ssh/id_ras を使って接続しています。この際に GitLab は ユーザーA がアクセスしてきたと解釈し、ユーザーBのリポジトリーにはアクセス権がないのでエラーを返します。 
ここ数日悩んでいたのですが、今日判りました。 ~/.ssh/config に IdentitiesOnly yesを追加すれば、指定した秘密キーのみが使われるのでした！ 

ということで ~/.ssh/config は以下の様に書きましょう 
Host user-b-repo 
Hostname gitlab.xxxx.com 
User git 
IdentityFile ~/.ssh/id_ras_git 
IdentitiesOnly yes', 
:user_id => 1
)

Post.create(
:title => 'Chef を学んで使ってみた',
:content => '空前の DevOps ブームに乗り遅れてはいけないとChefを学び、お客様の次期サーバーやRuby on Rails教育で使うサーバーを構築してみました。 

感想 

今回、お客様の次期サーバーを作るにあたりChefを使ってみたたところ、一度recipesを作ってしまえば サーバー環境が 10 ～30分くらいで自動的に出来てしまうのは画期的だと感じました！ 
私は教育・開発者なので、新しいサーバーの構築は年に数回、管理しているサーバーは数台程度です。従来はサーバーの構築・管理は手動で行い、作業内容をメモファイルに残していました。また、再度使う可能性があるサーバー環境はEC2のイメージとして保存して来たりしました。 
しかし、作業のメモは必ずしも完璧ではないですし、メモを見落としてインストールに失敗する事もままありました。また保存してあるイメージですが、RubyやRailsがバージョンアップし教育では使えなくなってしまう事もあります。 
手動でサーバー環境を構築しようとすると半日仕事になってしまいますが、Chefがあれば 10 ～30分くらい。しかも勝手にやってくれます。今までは、環境構築がおっくうで一つのサーバーに色々なアプリをrbenvとかを駆使して動かしていましたが、コスト面で問題がなければクラウドやVPSでサーバーを立ち上げ、すぐに環境が作れてしまいます。 
また、recipe はコードなので少し考えて作っておけば再利用が可能で、新たな環境用に Chef も比較的短時間で作れます。 
私のように、頻繁にサーバーを構築する事のない開発者も学んだ方が良い技術だと思います。 
学び方 

入門 

入門は、やはり naoyaさんの 入門Chef Solo を読みましょう。原理的な事から実践的な事までがコンパクトにまとっまている良い書籍だと思います。私は kindle版が出た時に買ってしまったのでMacの横にiPadを置きKindleアプリで見ながら作業をしましたが、今なら 達人出版会からPDF(EPUB)版を買えば PC, Mac で見ながら作業出来るので、こちらがお勧めです。',

:user_id => 1
)

Post.create(
:title => 'Postfix 2.10 から中継制限の設定が変わった',
:content => 'Ubuntu 13.04 を使ってRailsを動かす環境を作っていたのですが、ひさびさにはまり何時間もロスしてしまったので書いておきます。 

Postfixで SMTPで認証を行い任意のIPアドレスからメール中継を可能にする設定は、2.09までは main.cf に 
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination 
と指定します。検索すると、どこにもこの記述ができてきます。しかし Postfix 2.10 では 554 Relay access denied エラーになってしまいます・・・・ 
以前に設定した Ubuntu 12.04 (Postfix 2.09)の環境では上手く動作します。うぅぅぅ・・ 
いろいろと検索し、やっと http://www.postfix.org/SMTPD_ACCESS_README.html に答えが書いてありました 
NOTE: Postfix versions before 2.10 did not have smtpd_relay_restrictions. They combined the mail relay and spam blocking policies, under smtpd_recipient_restrictions. .... 
ということで、 smtpd_relay_restrictions を設定しましょう！ 
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination',
:user_id => 2
)

Post.create(
:title => 'Postfix 2.10 から中継制限の設定が変わった',
:content => "Ruby on Rails4.0.0が正式リリースされましたが、4.0.0RC1 までと JSON関連のコードが無いscaffoldを生成する方法が変わりました ^^; 

4.0.0RC1 までは、以下のオプションで JSON関連のコードが無い、きれいな controller と views の *.json.jbuilder が生成されませんでした。 
% rails g scaffold todo due:date task:string -c scaffold_controller 
しかし、Ruby on Rails4.0.0正式版 (4.0.0RC2から)は上のオプションでは JSON関連のコードが生成されてしまいます。--jbuilder=false を指定すれば *.json.jbuilder は生成されなくなりますが、controller には 醜い respond_to ～ format.json があります ^^; 
コードを見て判った事は、JSON関連のコード生成は jbuilder Gem が行っています。 したがって、Gemfile から jbuilder Gem をコメントアウトしてしまえばOKです。
結論 

Ruby on Rails4.0.0が正式でJSON関連のコードが無いscaffoldを生成するには 
Gemfile を以下のように変更します 
gem 'jbuilder', '~> 1.2' 
↓ 変更 
# gem 'jbuilder', '~> 1.2' ",
:user_id => 2
)