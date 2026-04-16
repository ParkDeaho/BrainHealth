import { useState, useCallback, useEffect } from 'react';
import type {
  WeatherData,
  WeatherInsight,
  WeatherImpact,
  BrainFortune,
  CoreMetrics,
  DailyCondition,
  DailyCheckIn,
  WeatherType,
  UserMode,
} from '../types';
import { getToday } from '../utils/date';

const WEATHER_KEY = 'bt_weather';
const CACHE_TTL_MS = 30 * 60 * 1000;

function load<T>(key: string, fallback: T): T {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch { return fallback; }
}

function save(key: string, data: unknown) {
  localStorage.setItem(key, JSON.stringify(data));
}

// MVP: 시뮬레이션 데이터 (추후 OpenWeatherMap / 기상청 API 교체)
function generateSimulatedWeather(): WeatherData {
  const types: WeatherType[] = ['sunny', 'cloudy', 'overcast', 'rain'];
  const month = new Date().getMonth();
  const baseTemp = month >= 5 && month <= 8 ? 28 : month >= 11 || month <= 2 ? 2 : 18;
  const variation = (Math.random() - 0.5) * 12;

  return {
    date: getToday(),
    temperature: Math.round((baseTemp + variation) * 10) / 10,
    humidity: Math.round(40 + Math.random() * 45),
    weatherType: types[Math.floor(Math.random() * types.length)],
    pm25: Math.round(10 + Math.random() * 80),
    feelsLike: Math.round((baseTemp + variation - 2 + Math.random() * 4) * 10) / 10,
    fetchedAt: Date.now(),
  };
}

export function useWeather() {
  const [weather, setWeather] = useState<WeatherData | null>(() => {
    const cached = load<WeatherData | null>(WEATHER_KEY, null);
    if (cached && cached.date === getToday() && Date.now() - cached.fetchedAt < CACHE_TTL_MS) return cached;
    return null;
  });

  const fetchWeather = useCallback(async () => {
    // TODO: 실제 API 호출로 교체
    // const res = await fetch(`/api/v1/weather/current?location=${locationCode}`);
    const data = generateSimulatedWeather();
    setWeather(data);
    save(WEATHER_KEY, data);
    return data;
  }, []);

  useEffect(() => {
    let cancelled = false;
    queueMicrotask(() => {
      if (cancelled) return;
      if (!weather || weather.date !== getToday() || Date.now() - weather.fetchedAt > CACHE_TTL_MS) {
        void fetchWeather();
      }
    });
    return () => {
      cancelled = true;
    };
  }, [weather, fetchWeather]);

  return { weather, fetchWeather };
}

// ===== 날씨 영향 분석 엔진 =====
export function analyzeWeatherImpact(
  weather: WeatherData | null,
  metrics: CoreMetrics,
  condition: DailyCondition | undefined,
  checkIn: DailyCheckIn | undefined,
): WeatherInsight {
  if (!weather) {
    return {
      impact: 'neutral',
      message: '날씨 정보를 불러오는 중입니다',
      detail: '',
      recommendation: '오늘 상태를 먼저 체크해보세요',
      icon: '🌤️',
    };
  }

  const { temperature, weatherType, humidity, pm25 } = weather;
  const sleepOk = condition ? condition.sleepHours >= 7 : checkIn ? checkIn.sleep >= 4 : true;
  const highFatigue = condition ? condition.fatigueLevel >= 4 : checkIn ? checkIn.fatigue >= 4 : false;
  const highStress = condition ? condition.stressLevel >= 4 : false;

  // 복합 조건 분석 (사용자 데이터 + 날씨)
  const factors: { impact: WeatherImpact; weight: number; msg: string; detail: string; rec: string; icon: string }[] = [];

  // 흐림 + 최근 집중 점수 낮음 (사용자 데이터 결합)
  if ((weatherType === 'cloudy' || weatherType === 'overcast') && metrics.focus > 0 && metrics.focus < 55) {
    factors.push({
      impact: 'focus_down', weight: 2,
      msg: '흐린 날씨와 최근 집중 점수가 겹쳐 집중이 흐트러지기 쉽습니다',
      detail: '날씨 영향과 측정된 집중력이 함께 낮은 편입니다',
      rec: '짧은 시간 단위로 나눠 진행하는 것이 좋습니다',
      icon: '☁️',
    });
  }

  // 흐림/비 + 수면부족 → 집중력 저하
  if ((weatherType === 'cloudy' || weatherType === 'overcast' || weatherType === 'rain') && !sleepOk) {
    factors.push({
      impact: 'focus_down', weight: 3,
      msg: '오늘은 집중이 쉽게 흐트러질 수 있는 환경입니다',
      detail: '흐린 날씨와 수면 부족이 겹쳐 집중력 저하가 예상됩니다',
      rec: '짧은 시간 단위로 나눠 진행하는 것이 좋습니다',
      icon: '🌧️',
    });
  }

  // 고온 + 피로 → 반응속도 저하
  if (temperature >= 28 && highFatigue) {
    factors.push({
      impact: 'speed_down', weight: 3,
      msg: '더운 날에는 반응속도가 느려질 수 있습니다',
      detail: '높은 기온과 피로감이 겹쳐 반응속도 저하가 예상됩니다',
      rec: '중요한 작업은 천천히 진행하는 것이 좋습니다',
      icon: '🌡️',
    });
  }

  // 저온 → 활동 감소 → 기억력 저하 가능
  if (temperature <= 5) {
    factors.push({
      impact: 'memory_down', weight: 2,
      msg: '추운 날에는 활동량이 줄어 기억력이 저하될 수 있습니다',
      detail: '낮은 기온으로 인한 활동 감소가 인지 기능에 영향을 줄 수 있습니다',
      rec: '실내에서 가벼운 기억력 훈련을 시도해보세요',
      icon: '🥶',
    });
  }

  // 미세먼지 높음 → 전반적 컨디션 저하
  if (pm25 >= 50) {
    factors.push({
      impact: 'focus_down', weight: 2,
      msg: '미세먼지가 높아 외출이 줄고 컨디션이 저하될 수 있습니다',
      detail: `미세먼지 PM2.5 ${pm25}μg/m³으로 실내 활동을 권장합니다`,
      rec: '실내 환기 후 호흡 훈련으로 컨디션을 관리하세요',
      icon: '😷',
    });
  }

  // 비 오는 날 + 높은 스트레스 → 무기력
  if (weatherType === 'rain' && highStress) {
    factors.push({
      impact: 'focus_down', weight: 2,
      msg: '비 오는 날 스트레스가 겹치면 무기력해지기 쉽습니다',
      detail: '우울한 날씨와 높은 스트레스가 활동 의욕을 낮출 수 있습니다',
      rec: '가벼운 호흡 훈련이나 짧은 게임으로 기분을 전환해보세요',
      icon: '🌧️',
    });
  }

  // 맑음 + 수면 양호 + 운동 → 기억력 상승
  if (weatherType === 'sunny' && sleepOk && condition?.exerciseYn) {
    factors.push({
      impact: 'memory_up', weight: 3,
      msg: '오늘은 기억 정리가 잘 되는 흐름입니다',
      detail: '좋은 날씨, 충분한 수면, 운동이 결합되어 최적의 상태입니다',
      rec: '암기나 정리 작업에 적합한 날입니다',
      icon: '☀️',
    });
  }

  // 맑음 + 적정 온도 → 집중력 상승
  if (weatherType === 'sunny' && temperature >= 15 && temperature <= 25 && humidity <= 65) {
    factors.push({
      impact: 'focus_up', weight: 2,
      msg: '오늘은 집중하기 좋은 쾌적한 환경입니다',
      detail: '맑은 날씨와 적정 기온으로 뇌 활동이 활발해질 수 있습니다',
      rec: '중요한 학습이나 작업을 진행하기 좋은 타이밍입니다',
      icon: '🌞',
    });
  }

  // 높은 습도 → 불쾌감
  if (humidity >= 80) {
    factors.push({
      impact: 'speed_down', weight: 1,
      msg: '높은 습도로 인해 불쾌감이 올 수 있습니다',
      detail: '습도가 높으면 피로감이 증가하고 반응속도가 저하됩니다',
      rec: '시원한 환경에서 가벼운 반응속도 훈련을 시도해보세요',
      icon: '💧',
    });
  }

  // 가장 중요한 영향 선택
  if (factors.length === 0) {
    return {
      impact: 'neutral',
      message: '오늘 날씨가 뇌 컨디션에 미치는 특별한 영향은 없습니다',
      detail: `${getWeatherLabel(weatherType)} ${temperature}°C`,
      recommendation: '평소대로 꾸준히 훈련하세요',
      icon: getWeatherIcon(weatherType),
    };
  }

  factors.sort((a, b) => b.weight - a.weight);
  const top = factors[0];
  return { impact: top.impact, message: top.msg, detail: top.detail, recommendation: top.rec, icon: top.icon };
}

// ===== 뇌 컨디션 운세 =====
export function generateBrainFortune(
  weather: WeatherData | null,
  metrics: CoreMetrics,
  condition: DailyCondition | undefined,
  mode: UserMode,
): BrainFortune {
  const today = getToday();

  if (!weather) {
    return {
      date: today,
      memoryForecast: '데이터를 수집하면 더 정확한 예측을 제공해요',
      focusForecast: '오늘 테스트를 진행해보세요',
      overallMessage: '꾸준한 측정이 가장 좋은 관리입니다',
      weatherFactor: '',
      icon: '🧠',
    };
  }

  const { temperature, weatherType, pm25, humidity } = weather;
  const wLabel = getWeatherLabel(weatherType);
  const sleepOk = condition ? condition.sleepHours >= 7 : true;

  // 기억력 운세
  let memoryForecast: string;
  if (weatherType === 'sunny' && sleepOk) {
    memoryForecast = '오늘은 기억력이 맑게 작동하는 날입니다. 새로운 것을 외우기에 좋아요.';
  } else if (weatherType === 'rain' || weatherType === 'overcast') {
    memoryForecast = '기억 흐름이 약간 흐릿할 수 있습니다. 반복 훈련으로 선명하게 만들어보세요.';
  } else if (temperature <= 5) {
    memoryForecast = '추운 날에는 몸이 움츠러들듯 기억력도 조금 느려질 수 있어요.';
  } else {
    memoryForecast = metrics.memory >= 70
      ? '기억력이 안정적인 흐름을 유지하고 있습니다.'
      : '간단한 기억력 게임으로 오늘의 상태를 확인해보세요.';
  }

  // 집중력 운세
  let focusForecast: string;
  if ((weatherType === 'cloudy' || weatherType === 'rain') && !sleepOk) {
    focusForecast = '집중 흐름이 조금 느슨해질 수 있습니다. 짧게 나눠 공부하면 효율이 올라갑니다.';
  } else if (weatherType === 'sunny' && temperature >= 15 && temperature <= 25) {
    focusForecast = '오늘은 집중하기 딱 좋은 환경입니다. 중요한 일을 앞에 배치하세요.';
  } else if (pm25 >= 50) {
    focusForecast = '미세먼지 영향으로 약간의 산만함이 올 수 있습니다. 실내에서 집중 훈련을 추천합니다.';
  } else if (humidity >= 75) {
    focusForecast = '습한 날씨가 불쾌감을 유발할 수 있어요. 쾌적한 환경 유지가 핵심입니다.';
  } else {
    focusForecast = metrics.focus >= 70
      ? '집중력이 좋은 흐름입니다. 이 컨디션을 유지하세요!'
      : '1분 집중 테스트로 오늘의 집중 상태를 체크해보세요.';
  }

  if ((condition?.anxietyLevel ?? 0) >= 4) {
    focusForecast = '마음이 불안하거나 긴장된 날에는 집중이 잠깐 끊기기 쉬워요. 호흡 후 짧은 과제부터 해보세요.';
  } else if (condition && condition.stressLevel >= 4) {
    focusForecast = '스트레스가 높게 느껴진다면 집중 흐름이 흔들릴 수 있어요. 짧게 나눠 진행해 보세요.';
  }
  if (condition && condition.motivationLevel <= 2) {
    memoryForecast = '의욕이 낮은 날에는 쉬운 난이도 기억 훈련부터 시작하면 부담이 적어요.';
  }

  // 전체 메시지 (모드별)
  let overallMessage: string;
  if (mode === 'student') {
    if (weatherType === 'rain' || weatherType === 'overcast') {
      overallMessage = '흐린 날 공부 효율이 떨어질 수 있어요. 25분 집중 + 5분 휴식 패턴을 추천합니다.';
    } else if (weatherType === 'sunny' && temperature <= 25) {
      overallMessage = '오늘은 공부하기 좋은 날이에요! 중요한 과목을 먼저 시작해보세요.';
    } else {
      overallMessage = '오늘 컨디션에 맞게 공부 리듬을 조절해보세요.';
    }
  } else if (mode === 'senior') {
    if (weatherType === 'rain' || pm25 >= 50) {
      overallMessage = '날씨 영향으로 활동량이 줄어들기 쉬운 날입니다. 가벼운 움직임과 간단한 기억 훈련이 도움이 됩니다.';
    } else if (weatherType === 'sunny' && temperature >= 10 && temperature <= 25) {
      overallMessage = '산책하기 좋은 날이에요. 걸으면서 가볍게 기억 훈련을 해보세요.';
    } else if (temperature <= 5) {
      overallMessage = '추운 날에는 실내에서 따뜻하게 뇌 훈련을 즐겨보세요.';
    } else {
      overallMessage = '오늘도 건강한 뇌를 위한 작은 습관을 이어가세요.';
    }
  } else {
    if (temperature >= 28) {
      overallMessage = '더운 날에는 뇌도 쉬어야 해요. 시원한 환경에서 짧은 훈련을 추천합니다.';
    } else if (weatherType === 'sunny' && sleepOk) {
      overallMessage = '오늘은 뇌 활동이 활발해질 수 있는 좋은 조건입니다!';
    } else {
      overallMessage = '오늘의 뇌 컨디션을 측정하고, 최적의 훈련을 찾아보세요.';
    }
  }

  return {
    date: today,
    memoryForecast,
    focusForecast,
    overallMessage,
    weatherFactor: `${wLabel} ${temperature}°C · 습도 ${humidity}% · PM2.5 ${pm25}`,
    icon: getWeatherIcon(weatherType),
  };
}

// ===== 7일 날씨 vs 점수 상관분석 =====
export function analyzeWeatherCorrelation(
  weatherHistory: WeatherData[],
  testResults: { date: string; score: number; category: string }[],
): string[] {
  const insights: string[] = [];
  if (weatherHistory.length < 3 || testResults.length < 3) return insights;

  const cloudyDays = weatherHistory.filter(w => w.weatherType === 'cloudy' || w.weatherType === 'overcast' || w.weatherType === 'rain');
  const sunnyDays = weatherHistory.filter(w => w.weatherType === 'sunny');

  const avgScore = (dates: string[]) => {
    const r = testResults.filter(t => dates.includes(t.date));
    return r.length > 0 ? r.reduce((s, t) => s + t.score, 0) / r.length : null;
  };

  const avgFocusScore = (dates: string[]) => {
    const r = testResults.filter(t => dates.includes(t.date) && t.category === 'focus');
    return r.length > 0 ? r.reduce((s, t) => s + t.score, 0) / r.length : null;
  };

  if (cloudyDays.length >= 2 && sunnyDays.length >= 2) {
    const cloudyAvg = avgFocusScore(cloudyDays.map(d => d.date));
    const sunnyAvg = avgFocusScore(sunnyDays.map(d => d.date));
    if (cloudyAvg !== null && sunnyAvg !== null && sunnyAvg - cloudyAvg > 5) {
      insights.push(`흐린 날 집중력 점수가 평균 ${Math.round(sunnyAvg - cloudyAvg)}점 낮았습니다`);
    }
  }

  const hotDays = weatherHistory.filter(w => w.temperature >= 28);
  if (hotDays.length >= 2) {
    const hotAvg = avgScore(hotDays.map(d => d.date));
    const normalDays = weatherHistory.filter(w => w.temperature >= 15 && w.temperature < 28);
    const normalAvg = avgScore(normalDays.map(d => d.date));
    if (hotAvg !== null && normalAvg !== null && normalAvg - hotAvg > 5) {
      insights.push(`기온이 높은 날 전반적 인지 점수가 ${Math.round(normalAvg - hotAvg)}점 낮았습니다`);
    }
  }

  const dustyDays = weatherHistory.filter(w => w.pm25 >= 50);
  if (dustyDays.length >= 2) {
    const dustyAvg = avgScore(dustyDays.map(d => d.date));
    const cleanDays = weatherHistory.filter(w => w.pm25 < 35);
    const cleanAvg = avgScore(cleanDays.map(d => d.date));
    if (dustyAvg !== null && cleanAvg !== null && cleanAvg - dustyAvg > 5) {
      insights.push(`미세먼지가 높은 날 인지 점수가 평균 ${Math.round(cleanAvg - dustyAvg)}점 낮았습니다`);
    }
  }

  return insights;
}

function getWeatherIcon(type: WeatherType): string {
  const icons: Record<WeatherType, string> = {
    sunny: '☀️', cloudy: '⛅', overcast: '☁️', rain: '🌧️', snow: '❄️', fog: '🌫️',
  };
  return icons[type] || '🌤️';
}

function getWeatherLabel(type: WeatherType): string {
  const labels: Record<WeatherType, string> = {
    sunny: '맑음', cloudy: '구름 조금', overcast: '흐림', rain: '비', snow: '눈', fog: '안개',
  };
  return labels[type] || '알 수 없음';
}

export { getWeatherIcon, getWeatherLabel };
