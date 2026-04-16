# BrainTrain (웹 프로토타입)

Flutter 네이티브 앱 구조·스택·MVP 순서는 [docs/flutter-mvp-architecture.md](docs/flutter-mvp-architecture.md)를 참고하세요.

**로컬 AI(Ollama)** 를 쓰려면 PC에서 Ollama를 설치·실행하고 모델을 받아 두어야 합니다. 절차는 [docs/ollama-local-setup.md](docs/ollama-local-setup.md)를 보세요. Windows에서는 `scripts/check-ollama.ps1`로 `11434` 응답 여부를 빠르게 확인할 수 있습니다.

**Windows에서 `flutter` 명령이 안 잡힐 때:** 이 저장소는 `flutter_sdk`에 Flutter를 두고 `tools/install_flutter_windows.ps1`로 사용자 PATH에 `flutter\bin`을 넣습니다. 새 터미널·IDE에서도 인식되려면 터미널을 완전히 닫았다가 열거나 Cursor를 한 번 재시작하세요. 그 전에도 **PATH 없이** 쓰려면 저장소 루트에서 `flutter_bundle.cmd`(예: `flutter_bundle.cmd --version`, `cd flutter_app` 후 `..\flutter_bundle.cmd run -d windows`) 또는 `flutter_app\flutter_local.cmd`를 사용하면 됩니다. 자세한 내용은 `flutter_app/SETUP.txt`를 참고하세요.

---

## React + TypeScript + Vite****

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Oxc](https://oxc.rs)
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/)

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:
****
```js
export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```
