import { ChangeEventHandler } from 'react';

export type SearchComponentProps = SearchProps;

export type SearchProps = {
  value: string;
  onChange: ChangeEventHandler<HTMLInputElement>;
  onReset: () => void;
};
