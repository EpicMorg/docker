#!/bin/sh

# Donation message
show_donation_message() {
  if [ "${EMG_DONATION_MESSAGE:-true}" != "false" ]; then
    echo "╔══════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                          ║"
    echo "║   Images are developed under the MIT license and are not the result of   ║"
    echo "║   commercial activity. If you'd like to support us, feel free to donate  ║"
    echo "║   using the wallet details below.                                        ║"
    echo "║                                                             Thank You!   ║"
    echo "║                                                                          ║"
    echo "╠═════════════════════╦════════════════════════════════════════════════════╣"
    echo "║ TYPE                ║ ADDRESS                                            ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ TON                 ║ EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg   ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ ETH                 ║ 0x26a8443a694f08cdfec966aa6fd72c45068753ec         ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ BTC                 ║ bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2         ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ LTC                 ║ ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg        ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ NVC                 ║ 4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6                 ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ DOGE                ║ DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6                 ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ PPC                 ║ pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB                 ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ RVN                 ║ R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3                 ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ ZEC                 ║ t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE                ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║ XMR                 ║ 884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJ  ║"
    echo "║                     ║ dYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1     ║"
    echo "╠═════════════════════╬════════════════════════════════════════════════════╣"
    echo "║                     ║ https://patreon.com/epicmorg                       ║"
    echo "║ WEB LINKS           ║ https://ko-fi.com/epicmorg                         ║"
    echo "║                     ║ https://ko-fi.com/alexz696                         ║"
    echo "╚═════════════════════╩════════════════════════════════════════════════════╝"
  fi
}


# Welcome message
show_welcome_message() {
  if [ "${EMG_WELCOME_MESSAGE:-true}" != "false" ]; then  
    echo "╔══════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                          ║"
    echo "║          Welcome to one of the containers of the project.                ║"
    echo "║                                                                          ║"
    echo "║  * EpicMorg directory with static binaries: '${EMG_LOCAL_BASE_DIR}'  ║"
    echo "║  * To disable Welcome  message switch 'EMG_WELCOME_MESSAGE'  to 'false'  ║"
    echo "║  * To disable Donation message switch 'EMG_DONATION_MESSAGE' to 'false'  ║"
    echo "║                                                                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════╝"
    show_donation_message
    echo "╔══════════════════════════════════════════════════════════════════════════╗"
    echo "║   Thank you for choosing us.                                             ║"
    echo "║                             Enjoy using the project!                     ║"
    echo "║                                                      EpicMorg, 2025      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════╝"
  fi
}

clear
show_welcome_message
exit 0
