import { useState } from 'react';
import { FilterablePlaylistsComponentProps } from '.';
import { PlaylistCity, PlaylistType } from '../Playlist';
import { Playlists } from '../Playlists';
import { PlaylistTypeSelector } from '../PlaylistTypeSelector';
import { Search } from '../Search';
import styles from './FilterablePlaylists.module.css';

export const FilterablePlaylists: React.FC<FilterablePlaylistsComponentProps> = ({
  playlists,
  source,
}: FilterablePlaylistsComponentProps) => {
  const [query, setQuery] = useState(``);
  const [
    filterPlaylistType,
    setFilterPlaylistType,
  ] = useState<PlaylistType | null>(null);

  const onChangePlaylistType = (type: PlaylistType | null) => {
    setFilterPlaylistType(type);
  };

  const onChangeSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setQuery(event.target.value);
  };

  const filterFunction = (city: PlaylistCity) =>
    city.PlaylistTitle.toUpperCase().indexOf(query.toUpperCase()) > -1 &&
    (filterPlaylistType === null || city.PlaylistType === filterPlaylistType);

  return (
    <div className={styles.filterablePlaylists}>
      <div className={styles.filterSection}>
        <div>
          <PlaylistTypeSelector onChange={onChangePlaylistType} />
        </div>
        <div className={styles.search}>
          <Search
            value={query}
            onChange={onChangeSearch}
            onReset={() => setQuery(``)}
          />
        </div>
      </div>

      <Playlists playlists={playlists.filter(filterFunction)} source={source} />
    </div>
  );
};
