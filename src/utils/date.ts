import { format, subDays, startOfDay, isToday as fnsIsToday } from 'date-fns';
import { ko } from 'date-fns/locale';

export const getToday = (): string => format(new Date(), 'yyyy-MM-dd');

export const formatDisplay = (dateStr: string): string =>
  format(new Date(dateStr), 'M월 d일 (EEE)', { locale: ko });

export const formatShort = (dateStr: string): string =>
  format(new Date(dateStr), 'M/d');

export const getLast7Days = (): string[] =>
  Array.from({ length: 7 }, (_, i) =>
    format(subDays(startOfDay(new Date()), 6 - i), 'yyyy-MM-dd')
  );

export const getLast14Days = (): string[] =>
  Array.from({ length: 14 }, (_, i) =>
    format(subDays(startOfDay(new Date()), 13 - i), 'yyyy-MM-dd')
  );

export const isToday = (dateStr: string): boolean =>
  fnsIsToday(new Date(dateStr));
