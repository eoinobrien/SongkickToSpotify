import { PlaylistType } from '../Playlist/Playlist.types';

export type PlaylistTypeSelectorComponentProps = PlaylistTypeSelectorProps;

export type PlaylistTypeSelectorProps = {
  onChange: (type: PlaylistType | null) => void;
};
