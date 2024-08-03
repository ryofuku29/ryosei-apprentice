PASSWORD_FILE="passwords.txt"

while true; do
    echo "パスワードマネージャーへようこそ！"
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read choice

    case $choice in
        "Add Password")
            echo "サービス名を入力してください："
            read service
            echo "ユーザー名を入力してください："
            read username
            echo "パスワードを入力してください："
            read password

            echo "$service:$username:$password" >> $PASSWORD_FILE
            echo "パスワードの追加は成功しました。"
            ;;
        "Get Password")
            echo "サービス名を入力してください："
            read service
            result=$(grep "^$service:" $PASSWORD_FILE)		#"^"があることによって行の先頭からのみ探せる
            if [ -z "$result" ]; then
                echo "そのサービスは登録されていません。"
            else
                IFS=':' read found_service found_username found_password <<< "$result"	#IFSは内部フィールド区切り文字（Internal Field Separator）で意味を持つ環境変数のため、ifsと書いてはいけない
                echo "サービス名：$found_service"
                echo "ユーザー名：$found_username"
                echo "パスワード：$found_password"
            fi
            ;;
        "Exit")
            echo "Thank you!"
            break
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done
