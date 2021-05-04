export type PlaylistComponentProps = PlaylistProps;

export type PlaylistProps = {
  playlist: PlaylistType;
};

export type PlaylistType = {
  PlaylistId: string;
  Offset: number;
  PlaylistTitle: string;
  Area: string;
  MetroId: string;
  PhotoCredit: string;
};
