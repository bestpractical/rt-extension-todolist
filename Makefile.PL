BEGIN { push @INC, '.' }
use inc::Module::Install;

RTx     'RT-Extension-TodoList';
license 'gpl_2';
repository 'https://github.com/bestpractical/rt-extension-todolist';

requires_rt '5.0.0';

sign;
WriteAll;
