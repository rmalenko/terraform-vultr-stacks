# regions
# curl "https://api.vultr.com/v2/regions" -X GET -H "Authorization: Bearer IOY....Q"

variable "VULTR_API_KEY" {
  type = string
}

variable "region_amsterdam_nl" {
  type    = string
  default = "ams"
}

variable "region_atlanta_us" {
  type    = string
  default = "atl"
}

variable "region_bangalore_india" {
  type    = string
  default = "blr"
}

variable "region_mumbai_india" {
  type    = string
  default = "bom"
}

variable "region_delhi_ncr_india" {
  type    = string
  default = "del"
}

variable "region_paris_fr" {
  type    = string
  default = "cdg"
}

variable "region_dallas_us" {
  type    = string
  default = "dfw"
}

variable "region_new_jersey_us" {
  type    = string
  default = "ewr"
}

variable "region_frankfurt_de" {
  type    = string
  default = "fra"
}

variable "region_honolulu_us" {
  type    = string
  default = "hnl"
}

variable "region_seoul_kr" {
  type    = string
  default = "icn"
}

variable "region_osaka_jp" {
  type    = string
  default = "itm"
}

variable "region_johannesburg_za" {
  type    = string
  default = "jnb"
}

variable "region_los_angeles_us" {
  type    = string
  default = "lax"
}

variable "region_london_gb" {
  type    = string
  default = "lhr"
}

variable "region_madrid_es" {
  type    = string
  default = "mad"
}

variable "region_manchester_gb" {
  type    = string
  default = "man"
}

variable "region_melbourne_au" {
  type    = string
  default = "mel"
}

variable "region_mexico_city_mx" {
  type    = string
  default = "mex"
}

variable "region_miami_us" {
  type    = string
  default = "mia"
}

variable "region_tokyo_jp" {
  type    = string
  default = "nrt"
}

variable "region_chicago_us" {
  type    = string
  default = "ord"
}

variable "region_sao_paulo_br" {
  type    = string
  default = "sao"
}

variable "region_santiago_cl" {
  type    = string
  default = "scl"
}

variable "region_seattle_us" {
  type    = string
  default = "sea"
}

variable "region_singapore_sg" {
  type    = string
  default = "sgp"
}

variable "region_silicon_valley_us" {
  type    = string
  default = "sjc"
}

variable "region_stockholm_se" {
  type    = string
  default = "sto"
}

variable "region_sydney_au" {
  type    = string
  default = "syd"
}

variable "region_tel_aviv_il" {
  type    = string
  default = "tlv"
}

variable "region_warsaw_pl" {
  type    = string
  default = "waw"
}

variable "region_toronto_ca" {
  type    = string
  default = "yto"
}

# OS type
# curl "https://api.vultr.com/v2/os" -X GET -H "Authorization: Bearer IOY....LQ"

variable "os_id_win_2012" {
  description = "Windows 2012 R2 Standard x64"
  type        = string
  default     = "124"
}

variable "os_id_centos_9" {
  description = "CentOS 9 Stream x64"
  type        = string
  default     = "542"
}

variable "os_id_freebsd_13" {
  description = "FreeBSD 13 x64"
  type        = string
  default     = "447"
}

variable "os_id_debian_12" {
  description = "Debian 12 x64 (bookworm)"
  type        = string
  default     = "2136"
}

variable "os_id_ubuntu_20_04_lts" {
  description = "Ubuntu 20.04 LTS x64"
  type        = string
  default     = "387"
}

# Plans
# curl "https://api.vultr.com/v2/plans" -X GET -H "Authorization: Bearer IO...LQ"

variable "plan_5_usd_vc2-1c-1gb" {
  description = "disk 25, bandwidth 1024"
  type        = string
  default     = "vc2-1c-1gb"
}

variable "plan_10_usd_vc2-1c-2gb" {
  description = "disk 55, bandwidth 2048"
  type        = string
  default     = "387"
}

