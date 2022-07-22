abstract class MovieStates{}

class MovieInitState extends MovieStates{}

class LoginStateSuccess extends MovieStates{}
class LoginStateFail extends MovieStates{}

class GetTrendingLoading extends MovieStates{}
class GetTrendingSuccess extends MovieStates{}
class GetTrendingError extends MovieStates{}

class GetNowPlayingLoading extends MovieStates{}
class GetNowPlayingSuccess extends MovieStates{}
class GetNowPlayingError extends MovieStates{}

class GetUpComingLoading extends MovieStates{}
class GetUpComingSuccess extends MovieStates{}
class GetUpComingError extends MovieStates{}

class GetCastLoading extends MovieStates{}
class GetCastSuccess extends MovieStates{}
class GetCastError extends MovieStates{}

class ChangeFavUIScreen extends MovieStates{}
class ChangeFavSuccessScreen extends MovieStates{}
class ChangeFavFailScreen extends MovieStates{}

class LoadingFavScreen extends MovieStates{}
class GetFavSuccessScreen extends MovieStates{}
class GetFavFailScreen extends MovieStates{}

class SignUpLoading extends MovieStates{}
class SignUpSuccess extends MovieStates{}
class SignUpError extends MovieStates{}

class SignInLoading extends MovieStates{}
class SignInSuccess extends MovieStates{}
class SignInError extends MovieStates{}