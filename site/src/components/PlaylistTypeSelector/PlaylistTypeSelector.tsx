import { useState } from 'react';
import { PlaylistTypeSelectorComponentProps } from '.';
import { PlaylistType } from '../Playlist';
import styles from './PlaylistTypeSelector.module.css';

export const PlaylistTypeSelector: React.FC<PlaylistTypeSelectorComponentProps> = ({
  onChange,
}: PlaylistTypeSelectorComponentProps) => {
  const [
    filterPlaylistType,
    setFilterPlaylistType,
  ] = useState<PlaylistType | null>(null);

  const onchange = ({ target }: React.ChangeEvent<HTMLInputElement>) => {
    let { value } = target as HTMLInputElement;
    value = value.charAt(0).toUpperCase() + value.slice(1);
    const playlistTypeClicked =
      PlaylistType[value as keyof typeof PlaylistType];

    if (filterPlaylistType === playlistTypeClicked) {
      setFilterPlaylistType(null);
      onChange(null);
    } else {
      setFilterPlaylistType(null);
      setFilterPlaylistType(playlistTypeClicked);
      onChange(playlistTypeClicked);
    }
  };

  return (
    <div className={styles.playlistTypeSelector}>
      <fieldset>
        <legend>Filter Playlist Type: </legend>
        <span>
          <input
            type="checkbox"
            id="upcoming"
            name="type"
            value="upcoming"
            checked={filterPlaylistType === PlaylistType.Upcoming}
            onChange={onchange}
            className={styles.playlistTypeSelectorCheckbox}
          />
          <label
            htmlFor="upcoming"
            className={styles.playlistTypeSelectorLabel}
          >
            Upcoming
          </label>
        </span>
        <span>
          <input
            type="checkbox"
            id="tonight"
            name="type"
            value="tonight"
            checked={filterPlaylistType === PlaylistType.Tonight}
            onChange={onchange}
            className={styles.playlistTypeSelectorCheckbox}
          />
          <label htmlFor="tonight" className={styles.playlistTypeSelectorLabel}>
            Tonight
          </label>
        </span>
      </fieldset>
    </div>
  );
};
