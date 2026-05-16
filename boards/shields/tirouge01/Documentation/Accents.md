| Lettre | Supported            | Unsupported     |
| :----: | :------------------- | :-------------- |
| A      | à â À Â              | á ä ã Á Ä Ã     |
| C      | ç Ç                  | ĉ Ĉ             |
| E      | é è ê ë É È Ê Ë      |                 |
| Ĝ      |                      | ĝ Ĝ             |
| Ĥ      |                      | ĥ Ĥ             |
| I      | í î ï Í Î Ï          | ì Ì             |
| N      |                      | ñ Ñ             |
| O      | ô Ô                  | ó ò ö õ Ó Ò Ö Õ |
| U      | ú ù û ü Ú Ù Û Ü      |                 |
| Y      |                      | ý ÿ Ý Ÿ         |
| Ĵ      |                      | ĵ Ĵ             |
| Ŝ      |                      | ŝ Ŝ             |


é à è ê ç â ô î û ù ï ë ü ö á ñ í ó ú ã õ ä ò ÿ ì ý ŝ ĉ ĝ ĵ ĥ
                                                

//                 ╔═══════╗                                                          ╔═══════╗
//         ╔═══════╣   ê   ╠═══════╦═══════╗                          ╔═══════╦═══════╣   *   ╠═══════╗
// ╔═══════╣   ë   ╠═══════╣   ô   ║   û   ║                          ║       ║   &   ╠═══════╣   (   ╠═══════╗
// ║   ^   ╠═══════╣   é   ╠═══════╬═══════╣                          ╠═══════╬═══════╣   %   ╠═══════║   )   ║
// ╠═══════╣   î   ╠═══════╣   à   ║   ù   ║                          ║       ║   $   ╠═══════╣   ?   ╠═══════╣
// ║   ç   ╠═══════╣   è   ╠═══════╬═══════╣                          ╠═══════╬═══════╣   @   ╠═══════║   ~   ║
// ╠═══════╣   ï   ╠═══════╣   â   ║   ´   ║                          ║       ║   !   ╠═══════╣   #   ╠═══════╣
// ║   `   ╠═══════╝       ╚═══════╩═══════╝                          ╚═══════╩═══════╝       ╚═══════║   ¨   ║
// ╚═══════╝                                                                                          ╚═══════╝



à = &kp BSLH               // "Backslash"
â = &kp LBKT &kp A         // "Left Bracket" + "A"
á = &kp RC(SEMI) &kp A     // "Right Control" + "Semicolon" + "A"
ä = &kp LS(LBKT) &kp A     // "Left Shift" + "Left Bracket" + "A"
ã = &kp RA(RBKT) &kp A     // "Right Alt" + "Right Bracket" + "A"
À = &kp LS(BSLH)           // "Left Shift" + "Backslash"
Â = &kp LBKT &kp LS(A)     // "Left Bracket" + "Left Shift" + "A"
Á = &kp RC(SEMI) &kp LS(A) // "Right Control" + "Semicolon" + "Left Shift" + "A"
Ä = &kp LS(LBKT) &kp LS(A) // "Left Shift" + "Left Bracket" + "Left Shift" + "A"
Ã = &kp RA(RBKT) &kp LS(A) // "Right Alt" + "Right Bracket" + "Left Shift" + "A"
ç = &kp RBKT               // "Right Bracket"
ĉ = &kp LBKT &kp C         // "Left Bracket" + "C"
Ç = &kp LS(RBKT)           // "Left Shift" + "Right Bracket"
Ĉ = &kp LBKT &kp LS(C)     // "Left Bracket" + "Left Shift" + "C"
é = &kp FSLH               // "Forward Slash"
è = &kp APOS               // "Apostrophe"
ê = &kp LBKT &kp E         // "Left Bracket" + "E"
ë = &kp LS(LBKT) &kp E     // "Left Shift" + "Left Bracket" + "E"
É = &kp LS(FSLH)           // "Left Shift" + "Forward Slash"
È = &kp LS(APOS)           // "Left Shift" + "Apostrophe"
Ê = &kp LBKT &kp LS(E)     // "Left Bracket" + "Left Shift" + "E"
Ë = &kp LS(LBKT) &kp LS(E) // "Left Shift" + "Left Bracket" + "Left Shift" + "E"
ĝ = &kp LBKT &kp G         // "Left Bracket" + "G" 
Ĝ = &kp LBKT &kp LS(G)     // "Left Bracket" + "Left Shift" + "G"
ĥ = &kp LBKT &kp H         // "Left Bracket" + "H" 
Ĥ = &kp LBKT &kp LS(H)     // "Left Bracket" + "Left Shift" + "H"
í = &kp RC(SEMI) &kp I     // "Right Control" + "Semicolon" + "I"
î = &kp LBKT &kp I         // "Left Bracket" + "I"
ï = &kp LS(LBKT) &kp I     // "Left Shift" + "Left Bracket" + "I"
ì = &kp RA(LBKT) &kp I     // "Right Alt" + "Left Bracket" + "I"
Í = &kp RC(SEMI) &kp LS(I) // "Right Control" + "Semicolon" + "Left Shift" + "I"
Î = &kp LBKT &kp LS(I)     // "Left Bracket" + "Left Shift" + "I"
Ï = &kp LS(LBKT) &kp LS(I) // "Left Shift" + "Left Bracket" + "Left Shift" + "I" 
Ì = &kp RA(LBKT) &kp LS(I) // "Right Alt" + "Left Bracket" + "Left Shift" + "I"
ñ = &kp RA(RBKT) &kp N     // "Right Alt" + "Right Bracket" + "N"
Ñ = &kp RA(RBKT) &kp LS(N) // "Right Alt" + "Right Bracket" + "Left Shift" + "N"
ô = &kp LBKT &kp O         // "Left Bracket" + "O"
ó = &kp RC(SEMI) &kp O     // "Right Control" + "Semicolon" + "O" 
ò = &kp RA(LBKT) &kp O     // "Right Alt" + "Left Bracket" + "O"
ö = &kp LS(LBKT) &kp O     // "Left Shift" + "Left Bracket" + "O"
õ = &kp RA(RBKT) &kp O     // "Right Alt" + "Right Bracket" + "O"
Ô = &kp LBKT &kp LS(O)     // "Left Bracket" + "Left Shift" + "O"
Ó = &kp RC(SEMI) &kp LS(O) // "Right Control" + "Semicolon" + "Left Shift" + "O"
Ò = &kp RA(LBKT) &kp LS(O) // "Right Alt" + "Left Bracket" + "Left Shift" + "O"
Ö = &kp LS(LBKT) &kp LS(O) // "Left Shift" + "Left Bracket" + "Left Shift" + "O"
Õ = &kp RA(RBKT) &kp LS(O) // "Right Alt" + "Right Bracket" + "Left Shift" + "O"
ú = &kp RC(SEMI) &kp U     // "Right Control" + "Semicolon" + "U"
ù = &kp RA(LBKT) &kp U     // "Right Alt" + "Left Bracket" + "U"
û = &kp LBKT &kp U         // "Left Bracket" + "U"
ü = &kp LS(LBKT) &kp U     // "Left Shift" + "Left Bracket" + "U"
Ú = &kp RC(SEMI) &kp LS(U) // "Right Control" + "Semicolon" + "Left Shift" + "U"
Ù = &kp RA(LBKT) &kp LS(U) // "Right Alt" + "Left Bracket" + "Left Shift" + "U" 
Û = &kp LBKT &kp LS(U)     // "Left Bracket" + "Left Shift" + "U"
Ü = &kp LS(LBKT) &kp LS(U) // "Left Shift" + "Left Bracket" + "Left Shift" + "U"
ý = &kp RC(SEMI) &kp Y     // "Right Control" + "Semicolon" + "Y"
ÿ = &kp LS(LBKT) &kp Y     // "Left Shift" + "Left Bracket" + "Y"
Ý = &kp RC(SEMI) &kp LS(Y) // "Right Control" + "Semicolon" + "Left Shift" + "Y"
Ÿ = &kp LS(LBKT) &kp LS(Y) // "Left Shift" + "Left Bracket" + "Left Shift" + "Y"
ĵ = &kp LBKT &kp J         // "Left Bracket" + "J"
Ĵ = &kp LBKT &kp LS(J)     // "Left Bracket" + "Left Shift" + "J"
ŝ = &kp LBKT &kp S         // "Left Bracket" + "S"
Ŝ = &kp LBKT &kp LS(S)     // "Left Bracket" + "Left Shift" + "S"

| Lettre | French usage (%) | Supported |
| :----: | :--------------- | :-------- |
| é      | 1.94             | YES       |
| è      | 0.31             | YES       |
| à      | 0.31             | YES       |
| ê      | 0.08             | YES       |
| ç      | 0.06             | YES       |
| ô      | 0.04             | YES       |
| â      | 0.03             | YES       |
| î      | 0.03             | YES       |
| û      | 0.02             | YES       |
| ù      | 0.02             | YES       |
| ï      | 0.01             | YES       |
| á      | 0.01             |           |
| ü      | 0.01             |           |
| ë      | 0.01             |           |
| ö      | 0.01             |           |
| ä      | 0                |           |
| ã      | 0                |           |
| ĉ      | 0                |           |
| ĝ      | 0                |           |
| ĥ      | 0                |           |
| í      | 0                |           |
| ì      | 0                |           |
| ĵ      | 0                |           |
| ñ      | 0                |           |
| ó      | 0                |           |
| ò      | 0                |           |
| õ      | 0                |           |
| ŝ      | 0                |           |
| ú      | 0                |           |
| ý      | 0                |           |
| ÿ      | 0                |           |
