#!/bin/bash
cd /Applications/Spotify.app/Contents/Resources/Apps

if [ ! -f xpui.spa.bak ]; then
  cp xpui.spa xpui.spa.bak
fi

unzip -p xpui.spa xpui.js > xpui.js #| sed -e 's/adsEnabled:\!0/adsEnabled:\!1/' -e 's/"allSponsorships"/""/' -e 's/\(.=.=>\)"free"/\1"premium"/' > xpui.js

perl -pi -w -e 's|adsEnabled:!0|adsEnabled:!1|' xpui.js
perl -pi -w -e 's|allSponsorships||' xpui.js
# perl -pi -w -e 's/(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===/$1"premium"===$2$3"free"===/g' xpui.js
# perl -pi -w -e 's/\(.=.=>\)"free"/$1"premium"/g' xpui.js
perl -pi -w -e 's/(case .:|async enable\(.\)\{)(this.enabled=.+?\(.{1,3},"audio"\),|return this.enabled=...+?\(.{1,3},"audio"\))((;case 4:)?this.subscription=this.audioApi).+?this.onAdMessage\)/$1$3.cosmosConnector.increaseStreamTime(-100000000000)/' xpui.js
# perl -pi -w -e 's|.(\?\[.{1,6}[a-zA-Z].leaderboard,)|false$1|' xpui.js
perl -pi -w -e 's|Enables quicksilver in-app messaging modal",default:\K!.(?=})|false|s' xpui.js
perl -pi -w -e 's#/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)#b#gs' xpui.js
perl -pi -w -e 's|(this\._product_state(?:_service)?=(.))|$1,$2.putOverridesValues({pairs:{ads:'\''0'\'',catalogue:'\''premium'\'',product:'\''premium'\'',type:'\''premium'\''}})|' xpui.js
perl -pi -w -e 's|\x00\K\x61(?=\x64\x2D\x6C\x6F\x67\x69\x63\x2F\x73)|\x00|' xpui.js
perl -pi -w -e 's|\x00\K\x73(?=\x6C\x6F\x74\x73\x00)|\x00|' xpui.js
perl -pi -w -e 's/(\(.,..jsxs\)\(.{1,3}|(.\(\).|..)createElement\(.{1,4}),\{(filterMatchQuery|filter:.,title|(variant:"viola",semanticColor:"textSubdued"|..:"span",variant:.{3,6}mesto,color:.{3,6}),htmlFor:"desktop.settings.downloadQuality.+?).{1,6}get\("desktop.settings.downloadQuality.title.+?(children:.{1,2}\(.,.\).+?,|\(.,.\){3,4},|,.\)}},.\(.,.\)\),)//' xpui.js
# perl -pi -w -e ' .BKsbV2Xl786X9a09XROH {display:none}' xpui.js
# perl -pi -w -e ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display:none}' xpui.js
perl -pi -w -e ' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}' xpui.js
perl -pi -w -e 's/(!Array.isArray\(.\)\|\|.===..length)/$1||e[0].key.includes('\''episode'\'')||e[0].key.includes('\''show'\'')/' xpui.js
perl -pi -w -e 's|sp://logging/v3/\w+||g' xpui.js
perl -pi -w -e 's|this\.getStackTop\(\)\.client=e|return;$&|' xpui.js

zip --update xpui.spa xpui.js                                              
rm xpui.js
