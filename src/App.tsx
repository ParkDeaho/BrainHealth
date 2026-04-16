import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import VersionBootstrap from './components/VersionBootstrap';
import { useProfile } from './store/useStore';
import Layout from './components/Layout';
import Onboarding from './pages/Onboarding';
import Home from './pages/Home';
import CheckIn from './pages/CheckIn';
import Questionnaire from './pages/Questionnaire';
import LifestyleCheck from './pages/LifestyleCheck';
import TestHub from './pages/TestHub';
import WordMemory from './pages/tests/WordMemory';
import DigitSpan from './pages/tests/DigitSpan';
import ReactionSpeed from './pages/tests/ReactionSpeed';
import StroopTest from './pages/tests/StroopTest';
import CPTTest from './pages/tests/CPTTest';
import VisualTracking from './pages/tests/VisualTracking';
import VisualPattern from './pages/tests/VisualPattern';
import TrailMaking from './pages/tests/TrailMaking';
import NumberMemory from './pages/NumberMemory';
import Training from './pages/Training';
import CardMatch from './pages/games/CardMatch';
import NBack from './pages/games/NBack';
import SelectiveFocus from './pages/games/SelectiveFocus';
import SequenceMemory from './pages/games/SequenceMemory';
import Breathing from './pages/games/Breathing';
import Report from './pages/Report';
import Routine from './pages/Routine';
import MyPage from './pages/MyPage';
import Guardian from './pages/Guardian';
import MindCheck from './pages/MindCheck';

function AppRoutes() {
  const { hasOnboarded } = useProfile();

  if (!hasOnboarded) {
    return (
      <Routes>
        <Route path="/onboarding" element={<Onboarding />} />
        <Route path="*" element={<Navigate to="/onboarding" replace />} />
      </Routes>
    );
  }

  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Home />} />
        <Route path="/checkin" element={<CheckIn />} />
        <Route path="/mind" element={<MindCheck />} />
        <Route path="/questionnaire" element={<Questionnaire />} />
        <Route path="/questionnaire/lifestyle" element={<LifestyleCheck />} />

        <Route path="/tests" element={<TestHub />} />
        <Route path="/tests/word-memory" element={<WordMemory />} />
        <Route path="/tests/digit-span" element={<DigitSpan />} />
        <Route path="/tests/reaction-speed" element={<ReactionSpeed />} />
        <Route path="/tests/stroop" element={<StroopTest />} />
        <Route path="/tests/cpt" element={<CPTTest />} />
        <Route path="/tests/visual-tracking" element={<VisualTracking />} />
        <Route path="/tests/visual-pattern" element={<VisualPattern />} />
        <Route path="/tests/trail-making" element={<TrailMaking />} />
        <Route path="/tests/number-memory" element={<NumberMemory />} />

        <Route path="/training" element={<Training />} />
        <Route path="/training/card-match" element={<CardMatch />} />
        <Route path="/training/nback" element={<NBack />} />
        <Route path="/training/selective-focus" element={<SelectiveFocus />} />
        <Route path="/training/sequence-memory" element={<SequenceMemory />} />
        <Route path="/training/breathing" element={<Breathing />} />
        <Route path="/training/number-memory" element={<NumberMemory />} />

        <Route path="/report" element={<Report />} />
        <Route path="/routine" element={<Routine />} />
        <Route path="/mypage" element={<MyPage />} />
        <Route path="/guardian" element={<Guardian />} />
      </Route>
      <Route path="/onboarding" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <VersionBootstrap>
        <AppRoutes />
      </VersionBootstrap>
    </BrowserRouter>
  );
}
