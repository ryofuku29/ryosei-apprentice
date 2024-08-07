PASSWORD_FILE="passwords.txt"
ENCRYPTED_FILE="passwords.txt.gpg"
PASSPHRASE="pass"

echo "パスワードマネージャーへようこそ！"
while true; do
	echo "次の選択肢から入力してください (Add Password/Get Password/Exit):"
	read choice
	case "$choice" in
		"Add Password")
			echo "サービス名を入力してください："
			read service
			echo "ユーザー名を入力してください："
			read username
			echo "パスワードを入力してください："
			read password

			if [ -f $ENCRYPTED_FILE ]; then
				gpg --batch --yes --passphrase "$PASSPHRASE" -o $PASSWORD_FILE -d $ENCRYPTED_FILE	#たまに複合に失敗します。原因不明
			fi
			echo "$service:$username:$password" >> $PASSWORD_FILE
			gpg --batch --yes --passphrase "$PASSPHRASE" -c $PASSWORD_FILE
			rm $PASSWORD_FILE
			echo "パスワードの追加は成功しました。"
		;;
		"Get Password")
			echo "サービス名を入力してください："
			read service

			if [ -f $ENCRYPTED_FILE ]; then
				gpg --yes --passphrase "$PASSPHRASE" -o $PASSWORD_FILE -d $ENCRYPTED_FILE
				result=$(grep "^$service:" $PASSWORD_FILE)
				if [ -z "$result" ]; then
					echo "そのサービスは登録されていません。"
				else
					IFS=':' read -r found_service found_username found_password <<< "$result"
					echo "サービス名：$found_service"
					echo "ユーザー名：$found_username"
					echo "パスワード：$found_password"
				fi

				rm $PASSWORD_FILE
			else
				echo "そのサービスは登録されていません。"
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
