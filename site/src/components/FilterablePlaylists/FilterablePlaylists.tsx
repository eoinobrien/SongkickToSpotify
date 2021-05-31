import { useState } from 'react';
import { FilterablePlaylistsComponentProps } from '.';
import { PlaylistCity } from '../Playlist';
import { Playlists } from '../Playlists';
import { Search } from '../Search';
import styles from './FilterablePlaylists.module.css';

export const FilterablePlaylists: React.FC<FilterablePlaylistsComponentProps> = ({
  playlists,
}: FilterablePlaylistsComponentProps) => {
  const [query, setQuery] = useState(``);

  const onchange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setQuery(event.target.value);
  };

  const filterFunction = (city: PlaylistCity) =>
    city.PlaylistTitle.toUpperCase().indexOf(query.toUpperCase()) > -1;

  return (
    <div className={styles.filterablePlaylists}>
      <Search value={query} onChange={onchange} onReset={() => setQuery(``)} />

      <Playlists playlists={playlists.filter(filterFunction)} />
    </div>
  );
};
