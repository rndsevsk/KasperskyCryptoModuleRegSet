# KasperskyCryptoModuleRegSet

Своеобразное решение проблемы обновлнеия антивируса Касперского редакции Strong encription поверх KES10 SP2 Light

>>В процессе установки произошла неисправимая ошибка. (Установленные библиотеки шифрования AES-256 не соответствуют библиотекам шифрования AES-56 в данном пакете.)

решение предложено **yurasek** - правкой ключа реестра CryptoModuleTypeName с aes56 на aes256 https://forum.kaspersky.com/index.php?/topic/383398-в-процессе-установки-произошла-неисправимая-ошибка-установленные-библиотеки-шифрования-aes-256-не-соответствуют-библиотекам-шифрования-aes-56-в-данном-пакете/&do=findComment&comment=2807677 

В переменной **$OU** указываем подразделение для поиска

*!Скрипт использует для управления PowerShell Remoting и должен запускаться с достаточными правами*

Для удаленного подключения к компьютеру через PowerShell Remoting на нем необходимо выполнить ряд настроек:

- Нужно разрешить удаленные подключения: Enable-PSRemoting -Force
- Запустить службу WinRM: Start-Service WinRM
- оздать правило Брандмауэра Windows, разрешающее входящие подключения по этому протоколу.

Удобнее всего это проделать через GPO

Компьютер, с которого планируется удаленно управлять другими компьютерами:

- Необходимо разрешить подключения к удаленным системам. Для предоставления доступа ко всем удаленным компьютерам, воспользуйтесь командой: **Set-Item wsman:\localhost\client\trustedhosts * -Force**
- Убедитесь, что файервол не блокирует исходящие подключения.
